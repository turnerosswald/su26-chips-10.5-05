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
class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :news_item
  validates :score, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :news_item_id }
  after_destroy :update_average_rating
  after_save :update_average_rating

  private

  def update_average_rating
    average = news_item.ratings.average(:score) || 0
    news_item.update_column(:average_rating, average)
  end
end
