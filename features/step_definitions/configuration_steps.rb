Given /^I am running the "([^\"]*)" example$/ do |example_name|
  Dollhouse.launch_from(PROJECT_ROOT + "/examples/#{example_name}")
end
When /^I have deleted the "([^\"]*)" file$/ do |filename|
  FileUtils.rm_rf(File.join(Dollhouse.root, filename))
end
