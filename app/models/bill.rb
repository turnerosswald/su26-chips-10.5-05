# frozen_string_literal: true

class Bill < ApplicationRecord
  self.inheritance_column = :_type_disabled

  has_many :bill_sponsorships, dependent: :destroy
  has_many :representatives, through: :bill_sponsorships

  def self.save_from_api(bill_data, summary_text)
    create!(
      title: bill_data['title'],
      congress: bill_data['congress'],
      number: bill_data['number'],
      original_chamber: bill_data['originChamber'],
      type: bill_data['type'],
      summary: summary_text
    )
  end
end
