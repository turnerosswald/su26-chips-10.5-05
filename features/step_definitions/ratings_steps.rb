# frozen_string_literal: true

Given('I am logged in as {string}') do |name|
  first_name, last_name = name.split(' ', 2)
  email = "#{name.parameterize}@example.com"

  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
    provider: 'google_oauth2',
    uid: SecureRandom.hex(8),
    info: { first_name: first_name, last_name: last_name || 'User', email: email }
  )

  visit '/auth/google_oauth2/callback'
  @current_user = User.find_by(email: email)
end

Given('{string} has a news item titled {string}') do |_rep_name, title|
  @news_item = @representative.news_items.create!(
    title: title,
    link: 'https://example.com/article',
    description: 'A news article for testing.'
  )
end

Given('I have already rated {string} {int}') do |title, score|
  news_item = @representative.news_items.find_by(title: title)
  news_item.ratings.create!(user: @current_user, score: score)
end

When('I visit the news item {string}') do |title|
  news_item = @representative.news_items.find_by(title: title)
  visit representative_news_item_path(@representative, news_item)
end

When('I rate the article {int}') do |score|
  select score.to_s, from: 'rating_score'
  click_button 'Submit Rating'
end

Then('the average rating should be {string}') do |rating|
  expect(page).to have_content("#{rating} / 5")
end
