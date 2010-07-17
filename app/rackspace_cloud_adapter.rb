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
    raise "Unknown instance_type of #{opts[:instance_type].inspect}. Permitted values are #{FLAVORS.keys.inspect}" unless flavor_num
    image_num = IMAGES[opts[:os]]
    raise "Unknown os of #{opts[:os].inspect}. Permitted values are #{IMAGES.keys.inspect}" unless image_num

    server = @conn.servers.create(:flavor_id => flavor_num, :image_id => image_num, :name => name)

    # make this asynch soon
    server.wait_for { ready? }

    callback.call
  end
end
