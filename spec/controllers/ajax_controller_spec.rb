# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AjaxController do
  let(:state) do
    State.create!(name: 'California', symbol: 'CA', fips_code: 6, is_territory: 0,
                  lat_min: 32.5, lat_max: 42.0, long_min: -124.5, long_max: -114.1)
  end

  it 'returns counties for a state as JSON' do
    County.create!(name: 'Alameda County', state: state, fips_code: 1, fips_class: 'H1')
    get :counties, params: { state_symbol: 'ca' }
    expect(response.body).to include('Alameda County')
  end
end
