# frozen_string_literal: true

class AddBirthdayAndGenderToRepresentatives < ActiveRecord::Migration[7.2]
  def change
    add_column :representatives, :birthday, :date unless column_exists?(:representatives, :birthday)
    add_column :representatives, :gender, :string unless column_exists?(:representatives, :gender)
  end
end
