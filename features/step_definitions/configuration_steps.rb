Given /^I am running the "([^\"]*)" example$/ do |example_name|
  Dollhouse.launch_from(PROJECT_ROOT + "/examples/#{example_name}")
end
