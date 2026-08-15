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
#  index_ratings_on_news_item_id  (news_item_id)
#  index_ratings_on_user_id       (user_id)
#
# Foreign Keys
#
#  news_item_id  (news_item_id => news_items.id)
#  user_id       (user_id => users.id)
#
FactoryBot.define do
  factory :rating do
    user { nil }
    news_item { nil }
    score { 1 }
  end
end
