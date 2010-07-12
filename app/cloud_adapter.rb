class CloudAdapter
  def initialize
    raise %Q{
      Must implement the following methods:

      boot_new_server(type, opts)
      - type is the server type defined in the loaded config
      - generally, opts has :machine_id, :ram_size, :data_center, :backup_image_id

      execute(server_name, cmd, opts)

    } unless [:boot_new_server, :execute].all? { |m| self.class.method_defined? m }
  end
end
