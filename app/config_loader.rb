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

  def first_boot &blk
    callbacks[:first_boot] = blk
  end

  def to_server
    Server[name, @instance_type, callbacks]
  end

  def callbacks
    @callbacks ||= {}
  end
end
