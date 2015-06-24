@autocomplete
Feature: Add Medicine to Cabinet

Scenario: I want to see available medications
  Given I am on the cabinet page
  When I start typing a medication name
  Then I should see the medication in the list

@exterior_integration
Scenario: I want to add a medication
  Given I am on the cabinet page
  And I start typing a medication name
  When I select that medication
  Then I should see the medication in my cabinet