class TestCloudAdapter < CloudAdapter
  def boot_new_server(type, name, opts = {})
    calls << {
      :method => :boot_new_server,
      :args => [type, name, opts],
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
