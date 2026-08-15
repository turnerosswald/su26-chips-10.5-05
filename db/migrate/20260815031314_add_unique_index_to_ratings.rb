# frozen_string_literal: true

class AddUniqueIndexToRatings < ActiveRecord::Migration[7.2]
  def change
    add_index :ratings, %i[user_id news_item_id], unique: true
  end
end
