Feature: People collection

  Background:
    Given I visit the homepage
    And I click on the "Staff Directory" link

  Scenario: Default sorting
    Then I should see a descending sort arrow next to the column "Staff Member"
    And all results on the first page should begin with "A"

  Scenario: Filtering by library and department
    When I select "Elmer Holmes Bobst Library" in the "Library" dropdown filter
    Then all results should have "Elmer Holmes Bobst Library" in the "Library" column

  Scenario: Filtering by department
    When I select "Library Leadership" in the "Library Department" dropdown filter
    Then all results should have "Library Leadership" in the "Library Department" column

  Scenario: Filtering by speciality
    And I select "See all Subject Specialists" in the "Subject Specialty" dropdown filter
    Then results should have a column "Subject Specialty"
    But results should not have a column "Library Department"

  Scenario: Reset
    When I select "Elmer Holmes Bobst Library" in the "Library" dropdown filter
    And I click "Reset"
    Then all results on the first page should begin with "A"

  Scenario: Resorting
    When I click the column title "Library"
      Then I should see "20 Cooper Square" in the results
      Then I should see a descending sort arrow next to the column "Library"
    When I click the column title "Library Department"
      Then I should see a descending sort arrow next to the column "Library Department"

  Scenario: Searching
    When I search for the term "barnaby"
    Then I should see only "Barnaby Alter" in the results

  Scenario: Table display
    Then all results should link from each column
