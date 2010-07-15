Then /^server "([^\"]*)" should be listed as a running instance$/ do |server_name|
  yaml = YAML::load(File.read("#{Dollhouse.root}/config/dollhouse/instances/servers.yml"))
  p yaml
  yaml[server_name]['status'].should == :running
end
