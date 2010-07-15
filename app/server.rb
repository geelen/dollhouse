class Server < Struct.new(:name, :instance_type, :callbacks)
  def babushka taskname
    Dollhouse.cloud_adapter.execute(name, "babushka '#{taskname}'")
  end
end
