require 'rails_helper'
RSpec.describe Event, type: :model do
  describe '#county_names_by_id' do
    it 'returns county names mapped to ids' do
      state = State.create!(name: 'California', symbol: 'CA')
      county1 = County.create!(
        name: 'Alameda',
        fips_code: '001',
        state: state)
      county2 = County.create!(
        name: 'Contra Costa',
        fips_code: '013',
        state: state)
      event = Event.create!(
        name: 'Town Hall',
        county: county1,
        start_time: 1.day.from_now,
        end_time: 2.days.from_now)
      expect(event.county_names_by_id).to eq(
        {
          'Alameda' => county1.id,
          'Contra Costa' => county2.id
        })
    end
    it 'returns an empty array when no county exists' do
      event = Event.new
      expect(event.county_names_by_id).to eq([])
    end
  end
end