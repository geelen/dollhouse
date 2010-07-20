module Dollhouse
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
      calls << {
                 :method => :execute,
                 :args => [server_name, cmd, opts],
                 :returns => true
      }
      true
    end

    def write_file(server_name, path, content, opts = {})
      calls << {
                 :method => :write_file,
                 :args => [server_name, path, content, opts],
                 :returns => true
      }
      true
    end

    def last_call
      calls.last
    end

    def calls
      @calls ||= []
    end
  end
end
