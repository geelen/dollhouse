Then /^a new server should be started of type "([^\"]*)" with name "([^\"]*)"$/ do |type, name|
  @server_boot_callback = Dollhouse.cloud_adapter.last_call[:args][1]
  Dollhouse.cloud_adapter.last_call.should == {
    :method => :boot_new_server,
    :args => [name, @server_boot_callback, {:type => type}],
    :returns => true
  }
end

When /^server "([^\"]*)" comes online$/ do |name|
  @server_boot_callback.call name
end

Then /^server "([^\"]*)" should be bootstrapped$/ do |name|
  # babushka runs start here
  last_two_calls = Dollhouse.cloud_adapter.calls[-2..-1]
  expected_commands = [
    %Q{headless=true bash -c "`wget -O- babushka.me/up/hard`"},
    %Q{babushka sources -a geelen git://github.com/geelen/babushka-deps},
  ]
  last_two_calls.zip(expected_commands).each { |call, cmd|
    call.should == {
      :method => :execute,
      :args => [name, cmd, {}],
      :returns => true
    }
  }
end
