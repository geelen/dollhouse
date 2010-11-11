module Dollhouse
  class Deployment
    attr_accessor :name, :servers

    def initialize name, servers
      @name = name
      @servers = servers
    end

    def initiate opts
      servers.each do |server|
        cloud_name = [opts[:prefix], server.name].compact.join("-")
        Dollhouse.cloud_adapter.boot_new_server cloud_name,
                                                lambda { server_online(cloud_name, server) },
                                                {:instance_type => server.instance_type, :os => server.os, :snapshot => server.snapshot}
      end
    end

    def self.[](deployment)
      raise "Unknown deployment #{deployment}" unless all.has_key? deployment.to_s
      all[deployment.to_s]
    end

    def self.register deployment
      all.merge! deployment.name.to_s => deployment
    end

    def self.all
      @all ||= {}
    end
  end
end
