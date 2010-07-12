Then /^a new server should be started with name "([^\"]*)"$/ do |name|
  Dollhouse.cloud_adapter.last_call.should == {
    :method => :boot_new_server,
    :args => [:staging, name, {}],
    :returns => true
  }
end
