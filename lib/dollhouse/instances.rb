module Dollhouse
  class Instances
    def initialize
      require 'yaml'
      @online_servers = {}
    end

    def server_came_online online_server
      @online_servers[online_server.name_in_cloud] = online_server
      save!
    end

    private

    def save!
      FileUtils.mkdir_p(Dollhouse.root + '/config/dollhouse/instances')
      File.open(Dollhouse.root + '/config/dollhouse/instances/servers.yml', 'w') { |f|
        YAML::dump(@online_servers, f)
      }
    end
  end
end
