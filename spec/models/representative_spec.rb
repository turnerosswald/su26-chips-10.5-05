# frozen_string_literal: true

# == Schema Information
#
# Table name: representatives
#
#  id           :integer          not null, primary key
#  address      :string
#  contact_form :string
#  facebook     :string
#  name         :string
#  ocdid        :string
#  party        :string
#  phone        :string
#  photo_url    :string
#  title        :string
#  twitter      :string
#  website      :string
#  youtube      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  bioguide_id  :string
#
require 'rails_helper'

# This file is a stub.
# You should add your own test cases.
# We recommend creating a file for each model in the database.

# RSpec.describe Representative do
# end
RSpec.describe Representative do
  describe '.civic_api_to_representative_params' do
    let(:geocodio_response) do
      {
        'results' => [
          {
            'response' => {
              'results' => [
                {
                  'fields' => {
                    'congressional_districts' => [
                      {
                        'name' => 'Congressional District 12',
                        'district_number' => 12,
                        'ocd_id' => 'ocd-division/country:us/state:ca/cd:12',
                        'current_legislators' => [
                          {
                            'type' => 'representative',
                            'bio' => {
                              'first_name' => 'Jane',
                              'last_name' => 'Doe',
                              'party' => 'Democrat',
                              'gender' => 'F'
                            },
                            'contact' => {
                              'url' => 'https://doe.house.gov',
                              'address' => '1234 Longworth House Office Building; Washington DC 20515',
                              'phone' => '202-225-0000'
                            },
                            'social' => {
                              'twitter' => 'repjanedoe'
                            },
                            'references' => {
                              'bioguide_id' => 'D000000',
                              'govtrack_id' => '412345'
                            }
                          }
                        ]
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
    end

    it 'does not create duplicate representatives' do
      described_class.civic_api_to_representative_params(geocodio_response)
      described_class.civic_api_to_representative_params(geocodio_response)

      expect(described_class.count).to eq(1)
    end
  end
end
