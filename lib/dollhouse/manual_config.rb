module Dollhouse
  class ManualConfig
    def execute(name, cmd, opts = {})
      #nasty, but sudo_password isn't valid for starting a connection
      sudo_password = opts.delete(:sudo_password)
      ssh_conn(Dollhouse.instances[name].ip, opts[:user] || 'root', opts) do
        exec cmd, {:sudo_password => sudo_password}
      end
    end

    def write_file(name, path, content, opts)
      ssh_conn(Dollhouse.instances[name].ip, opts[:user] || 'root', opts) do
        write_file(path) do |out|
          out.puts content
        end
      end
    end

    private

    def ssh_conn(host, user, opts, &blk)
      #nasty, but sudo_password isn't valid for starting a connection
      opts.delete(:sudo_password)
      ssh_conns[[host, user, opts]].instance_eval(&blk)
    end

    def ssh_conns
      @ssh_conns ||= Hash.new { |h, (host, user, opts)|
        h[[host, user, opts]] = RemoteServer.new(host, user, {:forward_agent => true}.merge(opts))
      }
    end
  end
end
