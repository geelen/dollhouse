def deployment name, &blk
  Dollhouse::Deployment.register(Dollhouse::DeployBuilder[name].tap { |d| d.instance_eval(&blk) }.to_deployment)
end

module Dollhouse
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

    def os o
      @os = o
    end

    def from_latest_snapshot snapshot_name
      @snapshot = snapshot_name
    end

    def first_boot &blk
      callbacks[:first_boot] = blk
    end

    def to_server
      Server[name, @instance_type, @os, @snapshot, callbacks]
    end

    def callbacks
      @callbacks ||= {}
    end
  end
end
