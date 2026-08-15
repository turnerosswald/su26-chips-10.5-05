require 'rails_helper'

RSpec.describe Bill, type: :model do
    let(:attributes) do
        {
            title: 'Example Bill',
            congress: 119,
            number: 123,
            original_chamber: 'House',
            type: 'HR',
            summary: 'Example summary'
        }
    end

    it 'is valid with all required fields' do
        expect(described_class.new(attributes)).to be_valid
    end

    it 'requires a title' do 
        bill = described_class.new(attributes.merge(title: nil))
        expect(bill).not_to be_valid
    end

    it 'formats its bill number' do
        bill = described_class.new(attributes)
        expect(bill.formatted_number).to eq('HR 123')
    end

    it 'prevents duplicate congress/type/number combinations' do
        described_class.create!(attributes)
        duplicate = described_class.new(attributes.merge(title: 'Another title'))
        expect(duplicate).not_to be_valid
    end
end