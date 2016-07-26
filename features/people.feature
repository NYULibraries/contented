Feature: People collection

  Background:
    Given I visit the homepage
    And I click on the "Staff Directory" link

  Scenario: Default sorting
    Then I should see a descending sort arrow next to the column "Staff Member"
    And all results on the first page should begin with "A"

  Scenario: Filtering by department
    When I select "Campus Media" in the "Library Department" dropdown filter
    Then all results should have "Campus Media" in the "Library Department" column

  Scenario: Filtering by speciality
    And I select "See all Subject Specialists" in the "Subject Specialty" dropdown filter
    Then results should have a column "Subject Specialty"
    But results should not have a column "Library Department"

  Scenario: Reset
    When I select "Campus Media" in the "Library Department" dropdown filter
    And I click "Reset"
    Then all results on the first page should begin with "A"

  Scenario: Resorting
    When I click the column title "Staff Member"
      Then I should see "Yong, Oscar" in the results
      Then I should see an ascending sort arrow next to the column "Staff Member"
    When I click the column title "Library Department"
      Then I should see a descending sort arrow next to the column "Library Department"

  Scenario: Searching
    When I search for the term "barnaby"
    Then I should see only "Alter, Barnaby" in the results

  Scenario: Table display
    Then all results should link from each column
