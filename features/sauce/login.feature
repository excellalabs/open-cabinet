@auth @selenium
Feature: Authenticate with Open Cabinet
  In order to access my cabinet
  As a Open Cabinet user
  I want to authenticate with the site

  Scenario: Sign in
    Given a user visits the login page
    When the user logs in with valid credentials
    Then the user will see their cabinet

  Scenario: Sign out
    Given a user is signed in
    When the user logs out
    Then the user will no longer be authenticated

  Scenario: Continue as guest
    Given a user visits the login page
    When I select to continue as guest
    Then I am taken to a fresh medicine cabinet
