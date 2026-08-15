# frozen_string_literal: true

# == Schema Information
#
# Table name: bills
#
#  id               :integer          not null, primary key
#  congress         :integer
#  number           :integer
#  original_chamber :string
#  summary          :text
#  title            :string
#  type             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Bill < ApplicationRecord
  self.inheritance_column = :_type_disabled

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
