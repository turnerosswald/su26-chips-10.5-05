# frozen_string_literal: true

class CreateBillSponsorships < ActiveRecord::Migration[7.2]
  def change
    create_table :bill_sponsorships do |t|
      t.references :bill, null: false, foreign_key: true
      t.references :representative, null: false, foreign_key: true
      t.timestamps
    end
    add_index :bill_sponsorships, %i[bill_id representative_id], unique: true
  end
end
