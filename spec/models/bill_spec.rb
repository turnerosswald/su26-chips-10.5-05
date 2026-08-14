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
require 'rails_helper'

RSpec.describe Bill do
  let(:bill_attributes) do
    {
      title: 'Test Bill',
      congress: 119,
      number: 134,
      original_chamber: 'House',
      type: 'HR',
      summary: 'a summary'
    }
  end

  it 'does not blow up when type is a bill type code' do
    expect { described_class.new(type: 'HR') }.not_to raise_error
  end

  it 'saves and can be found again' do
    bill = described_class.create!(bill_attributes)
    expect(described_class.find(bill.id).type).to eq('HR')
  end

  describe '.save_from_api' do
    let(:bill_data) do
      {
        'congress' => 119,
        'number' => '134',
        'originChamber' => 'House',
        'title' => 'Protecting our Communities from Sexual Predators Act',
        'type' => 'HR'
      }
    end

    it 'maps the api fields onto the right columns' do
      bill = described_class.save_from_api(bill_data, 'This bill does a thing.')

      expect(bill.title).to eq('Protecting our Communities from Sexual Predators Act')
      expect(bill.congress).to eq(119)
      expect(bill.original_chamber).to eq('House')
      expect(bill.summary).to eq('This bill does a thing.')
    end

    it 'casts number to an integer even though the api sends a string' do
      bill = described_class.save_from_api(bill_data, 'summary text')
      expect(bill.number).to eq(134)
    end
  end
end
