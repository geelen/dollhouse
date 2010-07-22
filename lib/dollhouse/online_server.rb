module Dollhouse
  class OnlineServer < Struct.new(:name_in_cloud, :server_name, :status)
    attr_accessor :user

    def bootstrap
      Dollhouse.cloud_adapter.execute(name_in_cloud, %Q{headless=true bash -c "`wget -O- babushka.me/up/hard`"}, :user => user)
    end

    def babushka taskname, vars = {}
      # not used yet, but this makes sense. --defaults (or headless) is the default!
      if vars == :no_defaults
        Dollhouse.cloud_adapter.execute(name_in_cloud, "babushka '#{taskname}'", :user => user)
      else
        if !vars.empty?
          write_file(".babushka/vars/#{taskname}", {
            :vars => vars.map_keys(&:to_s).map_values { |v| {:value => v} }
          }.to_yaml)
        end
        Dollhouse.cloud_adapter.execute(name_in_cloud, "babushka '#{taskname}' --defaults", :user => user)
      end
    end

    def shell cmd, opts = {}
      Dollhouse.cloud_adapter.execute(name_in_cloud, cmd, {:user => user}.merge(opts))
    end

    def write_file path, content, opts = {}
      Dollhouse.cloud_adapter.write_file(name_in_cloud, path, content, {:user => user}.merge(opts))
    end

    def destroy
      Dollhouse.cloud_adapter.destroy(name_in_cloud)
    end

    def as user, &blk
      old_user = self.user
      self.user = user
      blk.call
      self.user = old_user
    end
  end
end
