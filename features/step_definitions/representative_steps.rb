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

Given('Representative {string} exists with missing profile information') do |name|
  @representative = Representative.create!(
    name: name,
    ocdid: '999999',
    title: 'Representative',
    party: nil,
    photo_url: nil,
    phone: nil,
    twitter: nil
  )
end
Then('the representative profile should load successfully') do
  expect(page).to have_content(@representative.name)
  expect(page).to have_current_path(representative_path(@representative))
end
