class OnlineServer < Struct.new(:name_in_cloud, :server_name, :status)
  def bootstrap
    Dollhouse.cloud_adapter.execute(name_in_cloud, %Q{headless=true bash -c "`wget -O- babushka.me/up/hard`"})
    Dollhouse.cloud_adapter.execute(name_in_cloud, %Q{babushka sources -a geelen git://github.com/geelen/babushka-deps})
  end

  def babushka taskname
    Dollhouse.cloud_adapter.execute(name_in_cloud, "babushka '#{taskname}'")
  end
end
