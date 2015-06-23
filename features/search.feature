@search
@wip
Feature: View Search Results
  In order to view medicines I use
  As a Open Cabinet user
  I want to search for medicines I use

Scenario: Search for a medicine
  Given the user is viewing the search page
  When the user searches for "Advil"
  Then the user will see a list of medicines

Scenario: Search for a non existant medicine
  Given the user is viewing the search page
  When the user searches for "fake non existent medicine that shouldn't have results"
  Then the user will be prompted to search again