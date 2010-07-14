module Dollhouse
  def self.load_config(config_file)
    # may need something cleverer in the future
    require config_file
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
