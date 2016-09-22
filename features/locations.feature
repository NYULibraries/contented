Feature: Locations collection

  Background:
    Given I visit the homepage
    And I click on the "Libraries" link

  @wip
  Scenario: Resorting
    When I click the column title "Location"
      Then I should see "Avery Fisher Center for Music & Media" as the first result
    When I click the column title "Location"
      And I click on page "2"
      Then I should see "Avery Fisher Center for Music & Media" as the last result

  Scenario: Default sorting
    Then I should see "Elmer Holmes Bobst Library" as the first result

  Scenario: Default filtering
    Then the "Organization" filter should have "NYU" checked
    And the "Type" filter should have "Libraries" checked
    And the "Type" filter should have "Special Collections & Archives" checked

  Scenario: Refiltering
    When I uncheck "NYU" in the "Organization" filter
    And I check "Consortium & Affiliate Libraries" in the "Organization" filter
    Then I should see "Cooper Union Library" in the results
    But I should not see "Elmer Holmes Bobst Library" in the results

  Scenario: Searching
    When I search for the term "jack brause"
    Then I should see only "Jack Brause Library" in the results
