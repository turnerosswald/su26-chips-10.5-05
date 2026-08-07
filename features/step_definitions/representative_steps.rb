# frozen_string_literal: true

Given('Representative {string} exists') do |name|
  @representative = Representative.create!(
    name: name,
    ocdid: '412345',
    title: 'Representative',
    party: 'Democrat'
  )
end

When("I visit the representative's profile") do
  visit representative_path(@representative)
end

Then('I should see their name') do
  expect(page).to have_content(@representative.name)
end
