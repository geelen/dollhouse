Feature: Booting up a staging environment
  Scenario: Deploying a new staging server from scratch
    Given I have loaded the "staging-demo" configuration file
    When I initiate a new deployment
    Then a new server should be started with name "staging-demo-1"
    When server "staging-demo-1" comes online
    Then server "staging-demo-1" should be bootstrapped
    And server "staging-demo-1" should be given private github credentials
    And task "complete staging environment" should be invoked on "staging-demo-1"
