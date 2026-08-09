Feature: Representatives profile

    As a community member
    I want to view a representative's profile
    So that I can learn about them
    
    Scenario: Viewing the representative's name
        Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their name
    
    Scenario: Viewing the representative's party
      Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their party

    Scenario: Viewing the representative's birthday
      Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their birthday formatted

    Scenario: Viewing the representative's gender
      Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their gender

    Scenario: Viewing the representative's office address
      Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their address
        
    Scenario: Viewing the representative's phone
      Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their phone

    Scenario: Viewing the representative's contact form URL
      Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their contact_form

    Scenario: Viewing the representative's official website
      Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their website

    Scenario: Viewing the representative's Twitter
      Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their twitter

    Scenario: Viewing the representative's Facebook
      Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their facebook

    Scenario: Viewing the representative's YouTube handles
      Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their youtube

    Scenario: Viewing the representative's external ID
      Given Representative "Jane Doe" exists
        When I visit the representative's profile
        Then I should see their bioguide_id
    
    Scenario: Viewing a representative with missing fields
      Given Representative "John Doe" exists with only a name
      When I visit the representative's profile
      Then I should see their name
      And I should see "No contact information available."
      And I should see "No social media accounts available."
    
    Scenario: Viewing the representatives search page
        When I visit the representatives page
        Then I should see "Search for a Representative"
        
    Scenario: Representative name on news items links to profile
        Given Representative "Jane Doe" exists
        When I visit Jane Doe's news items page
        Then "Jane Doe" should link to the representative profile

