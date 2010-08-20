module Dollhouse
  class Instances
    def initialize
      require 'yaml'
    end

    def server_came_online online_server
      online_servers[online_server.name_in_cloud] = online_server
      save!
    end

    def [] name
      online_servers[name] or raise "Don't have any record of a server called #{name.inspect}!"
    end

    def online_servers
      @online_servers = if File.exists? "#{Dollhouse.root}/config/dollhouse/instances/servers.yml"
        YAML::load_file("#{Dollhouse.root}/config/dollhouse/instances/servers.yml") or {}
      else
        {}
      end
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
