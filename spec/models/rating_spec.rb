# frozen_string_literal: true

# == Schema Information
#
# Table name: ratings
#
#  id           :integer          not null, primary key
#  score        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  news_item_id :integer          not null
#  user_id      :integer          not null
#
# Indexes
#
#  index_ratings_on_news_item_id              (news_item_id)
#  index_ratings_on_user_id                   (user_id)
#  index_ratings_on_user_id_and_news_item_id  (user_id,news_item_id) UNIQUE
#
# Foreign Keys
#
#  news_item_id  (news_item_id => news_items.id)
#  user_id       (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Rating do
  let(:representative) do
    Representative.create!(name: 'Jane Doe', ocdid: 'ocd-rating-test', title: 'Representative')
  end

  let(:news_item) do
    NewsItem.create!(representative: representative, title: 'Test Article',
                     link: 'https://example.com/article', description: 'Test article description')
  end

  let(:user) { User.create!(uid: 'rating-user-1', provider: :developer, email: 'rating1@example.com') }
  let(:second_user) { User.create!(uid: 'rating-user-2', provider: :developer, email: 'rating2@example.com') }

  it 'accepts a rating between 1 and 5' do
    rating = described_class.new(user: user, news_item: news_item, score: 5)
    expect(rating).to be_valid
  end

  it 'rejects a rating greater than 5' do
    rating = described_class.new(user: user, news_item: news_item, score: 6)
    expect(rating).not_to be_valid
  end

  it 'rejects a rating less than 1' do
    rating = described_class.new(user: user, news_item: news_item, score: 0)
    expect(rating).not_to be_valid
  end

  it 'does not allow the same user to rate the same article twice' do
    described_class.create!(user: user, news_item: news_item, score: 5)
    duplicate_rating = described_class.new(user: user, news_item: news_item, score: 3)
    expect(duplicate_rating).not_to be_valid
  end

  it 'calculates the average rating for a news article' do
    described_class.create!(user: user, news_item: news_item, score: 5)
    described_class.create!(user: second_user, news_item: news_item, score: 3)
    expect(news_item.reload.average_rating.to_f).to eq(4.0)
  end
end
