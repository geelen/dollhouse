require 'fog'

class RackspaceCloudAdapter < CloudAdapter
  FLAVORS = {"256mb" => 1, "512mb" => 2}
  IMAGES = {"Ubuntu 10.04" => 49}

  def initialize
    @conn = Fog::Rackspace::Servers.new(
      :rackspace_api_key => Auth::Rackspace::API_KEY,
      :rackspace_username => Auth::Rackspace::USERNAME
    )
  end

  def boot_new_server(name, callback, opts)
    flavor_num = FLAVORS[opts[:instance_type]]
    raise "Unknown instance_type of #{instance_type.inspect}. Permitted values are #{FLAVORS.keys.inspect}"

  end
end
