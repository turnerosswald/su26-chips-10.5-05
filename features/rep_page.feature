Feature: Representatives profile

    As a community member
    I want to view a representative's profile
    So that I can learn about them
    
    @javascript
    Scenario: Viewing the representative's name
        Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their name
    Scenario: Viewing a representative with missing optional information
        Given Representative "John Smith" exists with missing profile information
        When I visit the representative's profile
        Then the representative profile should load successfully