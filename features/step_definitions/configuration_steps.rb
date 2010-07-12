Given /^I have loaded the "([^\"]*)" configuration file$/ do |name|
  Dollhouse.load_config(PROJECT_ROOT + "/examples/config/#{name}.rb")
end
