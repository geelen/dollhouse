class Deployment < Struct.new(:name, :servers)
  def initiate opts
    servers.each do |server|
      Dollhouse.cloud_adapter.boot_new_server opts[:prefix] + server.name, lambda { |server| server_online server }, {:type => server.instance_type}
    end
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
