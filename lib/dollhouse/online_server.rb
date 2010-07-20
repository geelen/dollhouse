module Dollhouse
  class OnlineServer < Struct.new(:name_in_cloud, :server_name, :status)
    def bootstrap
      Dollhouse.cloud_adapter.execute(name_in_cloud, %Q{headless=true bash -c "`wget -O- babushka.me/up/hard,next`"})
      Dollhouse.cloud_adapter.execute(name_in_cloud, %Q{babushka sources -a geelen git://github.com/geelen/babushka-deps})
    end

    def babushka taskname, vars = {}
      if !vars.empty?
        Dollhouse.cloud_adapter.write_file(name_in_cloud, "~/.babushka/vars/#{taskname}", {
          :vars => vars.map_keys(&:to_s)
        })
        Dollhouse.cloud_adapter.execute(name_in_cloud, "babushka '#{taskname}' --defaults")
      else
        Dollhouse.cloud_adapter.execute(name_in_cloud, "babushka '#{taskname}'")
      end
    end

    def destroy
      Dollhouse.cloud_adapter.destroy(name_in_cloud)
    end
  end
end
