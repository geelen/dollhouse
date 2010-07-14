Then /^a new server should be started of type "([^\"]*)" with name "([^\"]*)"$/ do |type, name|
  @server_boot_callback = Dollhouse.cloud_adapter.last_call[:args][1]
  Dollhouse.cloud_adapter.last_call.should == {
    :method => :boot_new_server,
    :args => [name, @server_boot_callback, {:type => type}],
    :returns => true
  }
end
