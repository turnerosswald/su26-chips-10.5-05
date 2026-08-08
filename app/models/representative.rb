# frozen_string_literal: true

# == Schema Information
#
# Table name: representatives
#
#  id           :integer          not null, primary key
#  address      :string
#  birthday     :date
#  contact_form :string
#  facebook     :string
#  gender       :string
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
class Representative < ApplicationRecord
  has_many :news_items, dependent: :delete_all

  # Review the Geocodio docs
  # https://www.geocod.io/docs/#congressional-districts
  def self.geocodio_search(query)
    geocodio_api_key = ENV.fetch('GEOCODIO_API_KEY', Rails.application.credentials[:GEOCODIO_API_KEY])
    raise ArgumentError, 'Missing GEOCODIO_API_KEY' if geocodio_api_key.blank?

    geocodio = Geocodio::Gem.new(geocodio_api_key)
    geocodio.geocode(query, ['cd'])
  end

  # NOTE: This info only grabs data for the most likely represenative district
  # given a search. It would be good to adapt this to show all possible
  # matching representatives for a search / county.
  # See https://www.geocod.io/docs/#data-appends-fields
  def self.civic_api_to_representative_params(rep_info)
    reps = []
    response = rep_info['results'][0]['response']
    fields = response['results'][0]['fields']
    @legislators = fields['congressional_districts'][0]['current_legislators']

    @legislators.each_with_index do |official, _index|
      official['name'] = "#{official.dig('bio', 'first_name')} #{official.dig('bio', 'last_name')}"
      title = official['type']
      # Inspect all the data that's there to make part 1 easier.
      # Rails.logger.debug official
      # official.dig('bio', 'party')
      ocdid = official.dig('references', 'govtrack_id')
      party = official.dig('bio', 'party')
      birthday = official.dig('bio', 'birthday')
      gender = official.dig('bio', 'gender')
      office_address = official.dig('contact', 'address')
      phone = official.dig('contact', 'phone')
      contact_form_url = official.dig('contact', 'contact_form')
      official_website = official.dig('contact', 'url')
      twitter = official.dig('social', 'twitter')
      facebook = official.dig('social', 'facebook')
      youtube_handles = official.dig('social', 'youtube')
      bioguide_id = official.dig('references', 'bioguide_id')

      reps << Representative.find_rep(official, ocdid: ocdid, title: title, party: party, birthday: birthday, gender: gender, address: office_address, phone: phone, contact_form: contact_form_url, website: official_website, twitter: twitter, facebook: facebook, youtube: youtube_handles, bioguide_id: bioguide_id)
    end
    reps
  end

  def self.find_rep(official, title: '', ocdid: '', party: '', birthday: '', gender: '', address: '', phone: '', contact_form: '', website: '', twitter: '', 
    facebook: '', youtube: '', bioguide_id: '')
    rep = Representative.find_by(ocdid: ocdid)
    if rep.nil?
      rep = Representative.new({ name: official['name'], ocdid: ocdid,
        title: title, party: party, birthday: birthday, 
        gender: gender, address: address, phone: phone, website: website,
        contact_form: contact_form, twitter: twitter, facebook: facebook, 
        youtube: youtube, bioguide_id: bioguide_id })
      if rep.save
        rep.update_from_geocodio(official)
        return rep
      end
    else
      rep.update_from_geocodio(official)
    end
    rep
  end

  def portrait_url
    return nil if bioguide_id.blank?

    "https://www.congress.gov/img/member/#{bioguide_id.downcase}_200.jpg"
  end

  def update_from_geocodio(official)
    self.title = official['type']
    self.ocdid = official.dig('references', 'govtrack_id')
    self.party = official.dig('bio', 'party')
    self.birthday = official.dig('bio', 'birthday')
    self.gender = official.dig('bio', 'gender')
    self.address = official.dig('contact', 'address')
    self.phone = official.dig('contact', 'phone')
    self.website = official.dig('contact', 'url')
    self.contact_form = official.dig('contact', 'contact_form')
    self.twitter = official.dig('social', 'twitter')
    self.facebook = official.dig('social', 'facebook')
    self.youtube = official.dig('social', 'youtube')
    self.bioguide_id = official.dig('references', 'bioguide_id')

    save!
    self
  end
end
