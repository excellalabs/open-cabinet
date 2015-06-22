Feature: Autocomplete

@autocomplete
Scenario: I want to see available medications
  Given I am on the home page
  When I start typing a medication name
  Then I should see the medication in the list