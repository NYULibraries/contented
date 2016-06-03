Feature: Services collection

  Background:
    Given I visit the homepage
    And I click on the "Services" link

  Scenario: Default display
    Then I should see a topic "Print, Copy, Scan"
      But the topic "Print, Copy, Scan" should not have a "See more" link
    Then I should see a topic "Borrowing"
      And the topic "Borrowing" should have a "See more" link
  Scenario: Searching
    When I search for the term "find a video"
    Then I should see "Find a Video" as the first topic result

  Scenario: Reset
    When I search for the term "find a video"
    And I click "Reset"
    Then I should see a topic "Print, Copy, Scan"
    And I should see a topic "Borrowing"
