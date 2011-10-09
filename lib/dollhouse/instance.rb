module Dollhouse
  class Instance < Struct.new(:instance_name, :deployment_name, :server_name, :ip)
    attr_accessor :user, :password

    def bootstrap args = []
      cloud_adapter.execute(instance_name, %Q{bash -c "`wget -O- babushka.me/up/#{[*args].push('hard').uniq.join(',')}`"}, default_opts)
    end

    def babushka taskname, vars = {}
      # not used yet, but this makes sense. --defaults (or headless) is the default!
      if vars == :no_defaults
        cloud_adapter.execute(instance_name, "babushka '#{taskname}'", default_opts)
      else
        cloud_adapter.execute(instance_name, "babushka '#{taskname}' --defaults #{cmdline_vars(vars)}", default_opts)
      end
    end

    def shell cmd, opts = {}
      cloud_adapter.execute(instance_name, cmd, default_opts.merge(opts))
    end

    def write_file path, content, opts = {}
      cloud_adapter.write_file(instance_name, path, content, default_opts.merge(opts))
    end

    def locally &blk
      local_adapter.instance_eval &blk
    end

    def as user, opts = {}, &blk
      old_user = self.user
      old_password = self.password
      self.user = user
      self.password = opts[:password]
      instance_eval(&blk)
      self.user = old_user
      self.password = old_password
    end

    def server
      deployment.servers.find { |s| s.name == server_name }
    end

    def deployment
      Deployment[self.deployment_name]
    end

    def run_task task_name
      instance_eval &server.callbacks[task_name]
    end

    def to_yaml
      {instance_name => {'deployment_name' => deployment_name, 'server_name' => server_name, 'ip' => ip}}
    end

    def self.from_yaml(hash)
      hash.map_values_with_keys { |k,v|
        Instance[k, v['deployment_name'], v['server_name'], v['ip']]
      }
    end

    private

    def default_opts
      opts = {}
      opts.merge!({:user => user}) if user
      opts.merge!({:sudo_password => password}) if password
      opts
    end

    def cmdline_vars vars
      vars.keys.map {|key|
        %{#{key}="#{vars[key].strip.gsub('"', '\"')}"}
      }.join(' ')
    end

    # This could return different adapters, that connect to servers in different ways. For now we have a simple
    def cloud_adapter
      @cloud_adapter ||= ManualConfig.new
    end
    def local_adapter
      @local_adapter ||= LocalAdapter.new
    end
  end
end
