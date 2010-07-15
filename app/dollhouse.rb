module Dollhouse
  def self.launch_from(dir)

    # may need something cleverer in the future
    require dir + '/config/dollhouse/config.rb'
    Dir.glob(dir + '/config/dollhouse/auth.rb').each { |f| require f } #optional require
    Dir.glob(dir + '/config/dollhouse/deployments/*.rb').each { |f| require f }
  end

  def self.initiate_deployment(deployment, opts = {})
    Deployment.initiate(deployment, opts)
  end

  def self.cloud_adapter=(cloud_adapter)
    @cloud_adapter = cloud_adapter
  end

  def self.cloud_adapter
    @cloud_adapter
  end
end
