class CloudAdapter
  def initialize
    raise %Q{
      Must implement the following methods:

      boot_new_server(name, callback, opts)
      - name is the unique id for the server in this cloud
      - callback is a lambda to be fired_off when that server comes online
      - generally, opts has :machine_id, :ram_size, :data_center, :backup_image_id

      execute(server_name, cmd, opts)

    } unless [:boot_new_server, :execute].all? { |m| self.class.method_defined? m }
  end
end
