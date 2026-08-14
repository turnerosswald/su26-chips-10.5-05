require 'rails_helper'

RSpec.describe BillsHelper do
  it 'builds the params needed to save a bill' do
    bill = { 'title' => 'Test Bill', 'congress' => 119, 'number' => '134', 'type' => 'HR', 'originChamber' => 'House' }

    expect(helper.save_bill_params(bill)).to eq(
      title: 'Test Bill', congress: 119, number: '134', bill_type: 'HR', original_chamber: 'House'
    )
  end
end
