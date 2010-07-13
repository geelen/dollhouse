def deployment name, &blk
  Deployment.register(DeployBuilder[name].tap { |d| d.instance_eval(&blk) }.to_deployment)
end

class DeployBuilder < Struct.new(:name)
  def to_deployment
    Deployment[name, @servers.map(&:to_server)]
  end

  def server server_name, &blk
    servers << ServerBuilder[server_name].tap { |s| s.instance_eval(&blk) }
  end

  def servers
    @servers ||= []
  end
end

class ServerBuilder < Struct.new(:name)
  def instance_type t
    @instance_type = t
  end

  def to_server
    Server[name, @instance_type]
  end
end
