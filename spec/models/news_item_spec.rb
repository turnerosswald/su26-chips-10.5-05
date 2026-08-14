# frozen_string_literal: true

# == Schema Information
#
# Table name: news_items
#
#  id                :integer          not null, primary key
#  description       :text
#  link              :string           not null
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  representative_id :integer          not null
#
# Indexes
#
#  index_news_items_on_representative_id  (representative_id)
#
require 'rails_helper'

RSpec.describe NewsItem do
  describe '.find_for' do
    let!(:representative) do
      Representative.create!(
        name: 'Jane Doe',
        ocdid: 'ocd-123',
        title: 'Representative'
      )
    end

    let!(:news_item) do
      described_class.create!(
        representative: representative,
        title: 'Test News',
        link: 'https://example.com/news',
        description: 'Test description'
      )
    end

    it 'finds a news item for the representative' do
      expect(described_class.find_for(representative.id)).to eq(news_item)
    end
  end
end
