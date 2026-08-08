# frozen_string_literal: true

Given('Representative {string} exists') do |name|
  @representative = Representative.create!(
    name: name,
    ocdid: '412345',
    title: 'Representative',
    party: 'Democrat',
    gender: 'F',
    birthday: Date.new(1970, 1, 1),
    address: '123 Capitol St, Washington DC 20515',
    phone: '202-555-0100',
    website: 'https://example.house.gov',
    contact_form: 'https://example.house.gov/contact',
    twitter: 'RepExample',
    facebook: 'RepExample',
    youtube: 'RepExample',
    bioguide_id: 'E000123'
  )
end

Given('Representative {string} exists with only a name') do |name|
  @representative = Representative.create!(
    name: name,
    ocdid: '999999',
    title: 'Representative'
  )
end

When("I visit the representative's profile") do
  visit representative_path(@representative)
end

Then('I should see their {word}') do |attribute|
  value = @representative.public_send(attribute)
  expect(page).to have_content(value)
end

Then('I should see their birthday formatted') do
  expect(page).to have_content(@representative.birthday.strftime('%B %-d, %Y'))
end
