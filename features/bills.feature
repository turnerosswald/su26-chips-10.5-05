Feature: Searching and saving bills from congress.gov

  Scenario: Searching for bills by congress and type
    When I visit the bills search page for congress "119" and type "hr"
    Then I should see "Protecting our Communities from Sexual Predators Act"

  Scenario: Saving a bill shows its detail page
    When I visit the bills search page for congress "119" and type "hr"
    And I click the save button for the first bill
    Then I should see "Protecting our Communities from Sexual Predators Act"
    And I should see "This bill requires DOJ to detain non-citizens arrested for sexual assault."

  Scenario: Bill search results are displayed in the required table format
    When I visit the bills search page for congress "119" and type "hr"
    Then I should see "Showing 1 of 10081 results"
    And I should see "#"
    And I should see "Title"
    And I should see "Congress"
    And I should see "Type"
    And I should see "Chamber"
    And I should see "Last Action"
    And I should see "HR 134"
    And I should see "Protecting our Communities from Sexual Predators Act"
    And I should see "119"
    And I should see "House"
    And I should see "Referred to the House Committee on the Judiciary."
    And I should see "Jan 3, 2025"
    And I should see "Save"