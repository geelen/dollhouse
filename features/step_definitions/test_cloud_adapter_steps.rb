Then /^a new server should be started of type "([^\"]*)" with name "([^\"]*)"$/ do |type, name|
  @server_boot_callbacks ||= {}
  @server_boot_callbacks[name] = Dollhouse.cloud_adapter.last_call[:args][1]
  Dollhouse.cloud_adapter.last_call.should == {
    :method => :boot_new_server,
    :args => [name, @server_boot_callbacks[name], {:type => type}],
    :returns => true
  }
end

When /^server "([^\"]*)" comes online$/ do |name|
  @server_boot_callbacks[name].call
end

Then /^server "([^\"]*)" should be bootstrapped$/ do |name|
  expect_to_have_been_executed name, [
    %Q{headless=true bash -c "`wget -O- babushka.me/up/hard`"},
    %Q{babushka sources -a geelen git://github.com/geelen/babushka-deps},
  ]
end

def expect_to_have_been_executed name, cmds
  executions = Dollhouse.cloud_adapter.calls.
                 select { |call| call[:method] == :execute && call[:args][0] == name }.
                 map { |call| call[:args][1] }
  cmds.each { |cmd| executions.should include(cmd) }
end

When /^babushka run "([^\"]*)" should be run on "([^\"]*)"$/ do |babs_run, name|
  expect_to_have_been_executed name, "babushka '#{babs_run}'"
end
