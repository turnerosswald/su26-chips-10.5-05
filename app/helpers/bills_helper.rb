# frozen_string_literal: true

module BillsHelper
  def save_bill_params(bill)
    {
      title: bill['title'],
      congress: bill['congress'],
      number: bill['number'],
      bill_type: bill['type'],
      original_chamber: bill['originChamber']
    }
  end
end
