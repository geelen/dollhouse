Then /^a new server should be started of type "([^\"]*)" with name "([^\"]*)"$/ do |type, name|
  @server_boot_callbacks ||= {}
  @server_boot_callbacks[name] = Dollhouse.cloud_adapter.last_call[:args][1]
  Dollhouse.cloud_adapter.last_call.should == {
    :method => :boot_new_server,
    :args => [name, @server_boot_callbacks[name], {:instance_type => type, :os => "Ubuntu 10.04"}],
    :returns => true
  }
end

When /^server "([^\"]*)" comes online$/ do |name|
  @server_boot_callbacks[name].call
end

Then /^server "([^\"]*)" should be bootstrapped$/ do |name|
  expect_to_have_been_executed name, nil,
    %Q{headless=true bash -c "`wget -O- babushka.me/up/hard`"}
end

def expect_to_have_been_executed name, user, *cmds
  executions = Dollhouse.cloud_adapter.calls.
                 select { |call| call[:method] == :execute && call[:args][0] == name }.
                 map { |call| {:cmd => call[:args][1], :user => call[:args][2][:user] }}
  cmds.each { |cmd| executions.should include({:cmd => cmd, :user => user}) }
end

Then /^babushka run "([^\"]*)" should be run on "([^\"]*)"$/ do |babs_run, name|
  expect_to_have_been_executed name, nil, "babushka '#{babs_run}' --defaults"
end

Then /^babushka run "([^\"]*)" should be run on "([^\"]*)" as "([^\"]*)"$/ do |babs_run, name, user|
  expect_to_have_been_executed name, user, "babushka '#{babs_run}' --defaults"
end
