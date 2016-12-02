Feature: About collection

  Background:
    Given I visit the homepage

  Scenario: RSS feed
    Then I should see 3 formatted RSS feed results under "Library News & Updates"
