# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration[7.2]
  def change
    create_table :ratings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :news_item, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
