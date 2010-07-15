module Dollhouse
  def self.launch_from(dir)
    self.root = dir
    # may need something cleverer in the future
    require dir + '/config/dollhouse/config.rb'
    Dir.glob(dir + '/config/dollhouse/auth.rb') { |f| require f } #optional require
    Dir.glob(dir + '/config/dollhouse/deployments/*.rb') { |f| require f }
  end

  def self.initiate_deployment(deployment, opts = {})
    Deployment.initiate(deployment, opts)
  end

  class << self
    attr_accessor :root, :cloud_adapter
  end
end
