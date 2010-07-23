module Dollhouse
  class RackspaceCloudAdapter < CloudAdapter
    FLAVORS = {"256mb" => 1, "512mb" => 2, "1024mb" => 3}
    IMAGES = {"Ubuntu 10.04" => 49}

    def conn
      require 'fog'
      @conn ||= Fog::Rackspace::Servers.new(
                  :rackspace_api_key => Auth::Rackspace::API_KEY,
                  :rackspace_username => Auth::Rackspace::USERNAME
      )
    end

    def boot_new_server(name, callback, opts)
      flavor_num = FLAVORS[opts[:instance_type]]
      raise "Unknown instance_type of #{opts[:instance_type].inspect}. Permitted values are #{FLAVORS.keys.inspect}" unless flavor_num
      image_num = if opts[:snapshot]
        image = conn.images.select { |i| i.created_at && i.name =~ Regexp.new(Regexp.escape(opts[:snapshot])) }.sort_by { |i| i.created_at }.last
        raise "Snapshot name of #{opts[:snapshot]} doesn't match any images!" unless image
        puts "Booting from image: #{image.inspect}"
        image.id
      else
        raise "Unknown os of #{opts[:os].inspect}. Permitted values are #{IMAGES.keys.inspect}" unless IMAGES[opts[:os]]
        IMAGES[opts[:os]]
      end

      puts "Booting server #{name}"
      server = conn.servers.create(:flavor_id => flavor_num, :image_id => image_num, :name => name)

      puts "Server booted: #{server.inspect}"
      # make this asynch soon
      server.wait_for { ready? }
      puts "Server #{name} online. Adding our private key"
      server.public_key_path = Auth::KEYPAIR + ".pub"
      server.setup
      puts "Done. Ready to go!"

      callback.call
    end

    def execute(name, cmd, opts = {})
      #nasty, but sudo_password isn't valid for starting a connection
      sudo_password = opts.delete(:sudo_password)
      ssh_conn(name, opts) do
        p "Executing: #{cmd}"
        exec cmd, {:sudo_password => sudo_password}
      end
    end

    def write_file(name, path, content, opts = {})
      ssh_conn(name, opts) do
        write_file(path) do |out|
          out.puts content
        end
      end
    end

    def destroy name
      server = get_server name
      puts "Killing server #{server.inspect}"
      server.destroy
      puts "Done."
    end

    def take_snapshot name, snapshot_name
      response = conn.create_image get_server(name).id, 'name' => snapshot_name
      puts "Created image: #{response.body['image'].inspect}"
    end

    private

    def ssh_conn(name, opts, &blk)
      #nasty, but sudo_password isn't valid for starting a connection
      opts.delete(:sudo_password)
      ssh_conns[[name, opts]].instance_eval(&blk)
    end

    def ssh_conns
      @ssh_conns ||= Hash.new { |h, (name, opts)|
        puts "Establishing connection to #{name}:"
        #change this to use instances.yml, or something
        server = get_server name
        host = server.addresses['public'].first
        user = opts[:user] || 'root'
        puts "Connecting to #{host} as #{user}..."

        h[[name, opts]] = RemoteServer.new(host, user, {:forward_agent => true}.merge(opts))
      }
    end

    def get_server name
      server = conn.servers.find { |s| s.name == name }
      raise "Can't find server #{name}" if server.nil?
      server
    end
  end
end
