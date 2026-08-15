Feature: Rating News Items
  As a logged in user
  I want to rate news articles
  So that I can share my opinion and see the average rating

  Background:
    Given Representative "Jane Doe" exists
    And "Jane Doe" has a news item titled "Big News"

  Scenario: A logged out user cannot rate an article
    When I visit the news item "Big News"
    Then I should not see "Rate Article"

  Scenario: A logged in user can rate an article
    Given I am logged in as "Test User"
    When I visit the news item "Big News"
    And I rate the article 4
    Then I should see "Rating was successfully saved."
    And the average rating should be "4.00"

  Scenario: A user can update their existing rating
    Given I am logged in as "Test User"
    And I have already rated "Big News" 2
    When I visit the news item "Big News"
    And I rate the article 5
    Then I should see "Rating was successfully saved."
    And the average rating should be "5.00"