When /^I initiate a new deployment$/ do
  Dollhouse.initiate_deployment :prefix => "cuke-"
end
