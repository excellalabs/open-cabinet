@interaction
Feature: View medicine interactions in cabinet

@exterior_integration
Scenario: Viewing medicine interactions in cabinet
  Given I have "Warfarin", "Ibuprofen", and "Tylenol Cough And Sore Throat" in my cabinet
  And I am on the cabinet page
  When I select "Warfarin" as my primary
  Then I should see "Warfarin" as my primary
  And that it interacts with "Ibuprofen"
  And that it does not interact with "Tylenol Cough And Sore Throat"

@exterior_integration
Scenario: I want to view information on the medicine
  Given I have "Warfarin", "Ibuprofen", and "Tylenol Cough And Sore Throat" in my cabinet
  And I am on the cabinet page
  When I select "Warfarin" as my primary
  Then I should see "Warfarin" as my primary
  And I should see label data
  