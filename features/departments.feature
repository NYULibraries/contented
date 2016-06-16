Feature: Departments collection

  Background:
    Given I visit the homepage
    And I click on the "Departments" link

  Scenario: Default sorting
    Then I should see a descending sort arrow next to the column "Department"
    And I should see "Access, Delivery & Resource Sharing Services" as the first result

  Scenario: Filtering
    When I select "NYU Abu Dhabi Library" in the "Located in" dropdown filter
    Then all results should have "NYU Abu Dhabi Library" in the "Located in" column

  Scenario: Reset
    When I select "NYU Abu Dhabi Library" in the "Located in" dropdown filter
    And I click "Reset"
    Then I should see "Access, Delivery & Resource Sharing Services" as the first result

  Scenario: Resorting
    When I click the column title "Located in"
    Then I should see a descending sort arrow next to the column "Located in"

  Scenario: Searching
    When I search for the term "KARMS"
    Then I should see only "Knowledge Access & Resource Management Services" in the results

  Scenario: Table display
    Then all results should link from each column
