Feature: Booting up a staging environment
  Background: Using the demo deployment
    Given I am running the "demo" example
    And I have deleted "config/dollhouse/instances"

  Scenario: Deploying a new staging server from scratch
    When I initiate a new deployment :staging
    Then a new server should be started of type "512mb" with name "cuke-staging-server"
    When server "cuke-staging-server" comes online
    Then server "cuke-staging-server" should be listed as a running instance
    And server "cuke-staging-server" should be bootstrapped
    And babushka run "geelen:geelen server configured" should be run on "cuke-staging-server"
    And babushka run "geelen:complete staging environment" should be run on "cuke-staging-server" as "app"
