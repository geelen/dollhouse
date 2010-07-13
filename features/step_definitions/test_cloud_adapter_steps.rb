Then /^a new server should be started of type "([^\"]*)" with name "([^\"]*)"$/ do |type, name|
  Dollhouse.cloud_adapter.last_call.should == {
    :method => :boot_new_server,
    :args => [type, name, {}],
    :returns => true
  }
end
