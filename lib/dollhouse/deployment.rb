module Dollhouse
  class Deployment < Struct.new(:name, :servers)
    def initiate opts
      servers.each do |server|
        cloud_name = [opts[:prefix], server.name].compact.join("-")
        Dollhouse.cloud_adapter.boot_new_server cloud_name,
                                                lambda { server_online(cloud_name, server) },
                                                {:instance_type => server.instance_type, :os => server.os, :snapshot => server.snapshot}
      end
    end

    def server_online cloud_name, server
      online_server = OnlineServer[cloud_name, server.name, :running]
      Dollhouse.instances.server_came_online online_server
      online_server.bootstrap
      online_server.instance_eval &server.callbacks[:first_boot]
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
end
