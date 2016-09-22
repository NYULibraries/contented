Feature: About collection

  Background:
    Given I visit the homepage
    And I click on the "About" link

  Scenario: Default display
    Then I should see a topic "History"
    And I should see a topic "Who We Are"
    And I should see a topic "Using NYU Libraries"
    And I should see a topic "Collections"

  Scenario: Searching
    When I search for the term "library hours"
    Then I should see "Library Hours" as the first topic result

  Scenario: Reset
    When I search for the term "library hours"
    And I click "Reset"
    Then I should see a topic "History"
    And I should see a topic "Who We Are"
    And I should see a topic "Using NYU Libraries"
    And I should see a topic "Collections"
