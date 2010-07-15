class Deployment < Struct.new(:name, :servers)
  def initiate opts
    servers.each do |server|
      cloud_name = opts[:prefix] + server.name
      Dollhouse.cloud_adapter.boot_new_server cloud_name, lambda { server_online cloud_name, server }, {:type => server.instance_type}
    end
  end

  def server_online cloud_name, server
    #bootstrap
    Dollhouse.cloud_adapter.execute server, %Q{headless=true bash -c "`wget -O- j.mp/babushkamehard`"}
    Dollhouse.cloud_adapter.execute server, %Q{babushka sources -a geelen git://github.com/geelen/babushka-deps}
    server.instance_eval &server.callbacks[:first_boot]
  end

  def self.initiate deployment, opts
    raise "Unknown deployment #{deployment}" unless all.has_key? deployment
    all[deployment].initiate opts
  end

  def self.register deployment
    all.merge! deployment.name => deployment
  end

  def self.all
    @all ||= {}
  end
end
