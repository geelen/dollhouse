module Dollhouse
  class OnlineServer < Struct.new(:name_in_cloud, :deployment_name, :server_name, :status)
    attr_accessor :user, :password

    def bootstrap
      Dollhouse.cloud_adapter.execute(name_in_cloud, %Q{headless=true bash -c "`wget -O- babushka.me/up/hard`"}, default_opts)
    end

    def babushka taskname, vars = {}
      # not used yet, but this makes sense. --defaults (or headless) is the default!
      if vars == :no_defaults
        Dollhouse.cloud_adapter.execute(name_in_cloud, "babushka '#{taskname}'", default_opts)
      else
        if !vars.empty?
          write_file(".babushka/vars/#{taskname}", {
            :vars => vars.map_keys(&:to_s).map_values { |v| {:value => v} }
          }.to_yaml)
        end
        Dollhouse.cloud_adapter.execute(name_in_cloud, "babushka '#{taskname}' --defaults", default_opts)
      end
    end

    def shell cmd, opts = {}
      Dollhouse.cloud_adapter.execute(name_in_cloud, cmd, default_opts.merge(opts))
    end

    def write_file path, content, opts = {}
      Dollhouse.cloud_adapter.write_file(name_in_cloud, path, content, default_opts.merge(opts))
    end

    def destroy
      Dollhouse.cloud_adapter.destroy(name_in_cloud)
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

    def take_snapshot name
      Dollhouse.cloud_adapter.take_snapshot(name_in_cloud, name + "-" + Time.now.strftime("%Y%M%d-%H%M%S"))
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

    private

    def default_opts
      opts = {}
      opts.merge!({:user => user}) if user
      opts.merge!({:sudo_password => password}) if password
      opts
    end
  end
end
