# frozen_string_literal: true

When(/^I visit the bills search page for congress "(.*)" and type "(.*)"$/) do |congress, type|
  visit bills_path(congress: congress, bill_type: type)
end

When(/^I click the save button for the first bill$/) do
  first(:button, 'Save').click
end
