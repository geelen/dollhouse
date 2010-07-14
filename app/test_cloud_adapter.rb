class TestCloudAdapter < CloudAdapter
  def boot_new_server(name, callback, opts = {})
    calls << {
      :method => :boot_new_server,
      :args => [name, callback, opts],
      :returns => true
    }
    true
  end

  def execute(server_name, cmd, opts = {})

  end

  def last_call
    calls.last
  end

  private

  def calls
    @calls ||= []
  end
end
