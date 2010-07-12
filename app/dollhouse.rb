module Dollhouse
  def self.load_config(config_file)

  end

  def self.initiate_deployment(opts = {})
    @cloud_adapter.boot_new_server(:staging, "cuke-staging")
  end

  def self.cloud_adapter=(cloud_adapter)
    @cloud_adapter = cloud_adapter
  end

  def self.cloud_adapter
    @cloud_adapter
  end
end
