module Dollhouse
  class << self
    attr_accessor :root, :instances

    def launch_from(dir)
      self.root = dir
      # may need something cleverer in the future
      raise "You should be running this in your application root, or at least somewhere with a config/dollhouse subdirectory" if !File.exists?(File.join(dir, 'config', 'dollhouse'))
      Dir.glob(dir + '/config/dollhouse/config.rb') { |f| require f } #optional require
      Dir.glob(dir + '/config/dollhouse/auth.rb') { |f| require f } #optional require
      Dir.glob(dir + '/config/dollhouse/deployments/*.rb') { |f| require f }
    end

    def run(server_name, task_name)
      instances[server_name].run_task task_name
    end

    def execute(server_name, cmd)
      instances[server_name].instance_eval cmd
    end

    def instances
      @instances ||= Instances.new
    end
  end
end
