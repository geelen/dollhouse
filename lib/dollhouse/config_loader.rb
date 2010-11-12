def deployment name, &blk
  Dollhouse::Deployment.register(Dollhouse::DeployBuilder[name].tap { |d| d.instance_eval(&blk) }.to_deployment)
end

module Dollhouse
  class DeployBuilder < Struct.new(:name)
    def to_deployment
      Deployment.new(name, servers.map(&:to_server))
    end

    def server server_name, &blk
      servers << ServerBuilder[server_name].tap { |s| s.instance_eval(&blk) }
    end

    def servers
      @servers ||= []
    end
  end

  class ServerBuilder < Struct.new(:name)
    def task name, &blk
      callbacks[name.to_s] = blk
    end

    def to_server
      Server[name, @instance_type, @os, @snapshot, callbacks]
    end

    def callbacks
      @callbacks ||= {}
    end
  end
end
