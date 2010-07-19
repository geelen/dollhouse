require 'fog'

class RackspaceCloudAdapter < CloudAdapter
  FLAVORS = {"256mb" => 1, "512mb" => 2}
  IMAGES = {"Ubuntu 10.04" => 49}

  def conn
    Fog.mock!
    @conn ||= Fog::Rackspace::Servers.new(
      :rackspace_api_key => Auth::Rackspace::API_KEY,
      :rackspace_username => Auth::Rackspace::USERNAME
    )
  end

  def boot_new_server(name, callback, opts)
    flavor_num = FLAVORS[opts[:instance_type]]
    raise "Unknown instance_type of #{opts[:instance_type].inspect}. Permitted values are #{FLAVORS.keys.inspect}" unless flavor_num
    image_num = IMAGES[opts[:os]]
    raise "Unknown os of #{opts[:os].inspect}. Permitted values are #{IMAGES.keys.inspect}" unless image_num

    server = conn.servers.create(:flavor_id => flavor_num, :image_id => image_num, :name => name)
    puts "Booting server #{name}"

    # make this asynch soon
    server.wait_for { ready? }

    puts "Server #{name} online."

    callback.call
  end

  def execute(name, cmd, opts = {})
    #change this to use instances.yml, or something
    server = conn.servers.find { |s| s.name == name }
    puts "Connecting to #{host} as #{user}..."
    Net::SSH.start(server.addresses[:public], opts[:user] || 'root', {:forward_agent => true}.merge(opts)) do |ssh|
      
    end
  end
end
