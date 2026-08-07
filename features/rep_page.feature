Feature: Representatives profile

    As a community member
    I want to view a representative's profile
    So that I can learn about them
    
    @javascript
    Scenario: Viewing the representative's name
        Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their name