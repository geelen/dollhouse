When /^I initiate a new deployment :(\w+)$/ do |deployment|
  Dollhouse.initiate_deployment deployment.to_sym, :prefix => "cuke"
end
