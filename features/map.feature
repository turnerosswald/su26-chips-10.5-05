Feature: ActionMap Shows State and County Maps
@javascript
Scenario: Navigating States and counties
  Given I am on the homepage
  Then I should see "National Map"
  When I click the state "CA"
  Then I should see "California"
  And I should be on the state page for "CA"
  And the county map should include "Alameda County"
  And the county map should include "Sacramento County"

Scenario: Searching by county shows representatives
  When I visit the representative search page for "Skagit County, WA"
  Then I should see "Rick Larsen"
  And I should see "Patty Murray"
  And I should see "Maria Cantwell"

@javascript
Scenario: Counties are clickable on the California map
  Given I am on the homepage
  When I click the state "CA"
  Then "Sacramento County" should be a clickable county