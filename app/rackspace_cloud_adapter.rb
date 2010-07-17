class RackspaceCloudAdapter < CloudAdapter
  FLAVORS = {"256mb" => 1, "512mb" => 2}
  IMAGES = {}

  def initialize
    @cs = CloudServers::Connection.new(:username => Auth::Rackspace::USERNAME, :api_key => Auth::Rackspace::API_KEY)
  end

  def boot_new_server(name, callback, opts)
    flavor_num = FLAVORS[opts[:instance_type]]
    raise "Unknown instance_type of #{instance_type.inspect}. Permitted values are #{FLAVORS.keys.inspect}"

  end
end
