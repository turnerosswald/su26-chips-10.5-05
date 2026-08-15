Feature: Searching and saving bills from congress.gov

  Scenario: Searching for bills by congress and type
    When I visit the bills search page for congress "119" and type "hr"
    Then I should see "Protecting our Communities from Sexual Predators Act"

  Scenario: Saving a bill shows its detail page
    When I visit the bills search page for congress "119" and type "hr"
    And I click the save button for the first bill
    Then I should see "Protecting our Communities from Sexual Predators Act"
    And I should see "This bill requires DOJ to detain non-citizens arrested for sexual assault."