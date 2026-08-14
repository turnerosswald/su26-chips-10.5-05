# frozen_string_literal: true

# == Schema Information
#
# Table name: news_items
#
#  id                :integer          not null, primary key
#  description       :text
#  issue             :string
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
    describe '.issues' do
    it 'returns the required list of issues' do
      expect(described_class.issues).to include(
        'Free Speech',
        'Immigration',
        'Climate Change',
        'Gun Control',
        'Equal Pay'
      )
    end
  end

  describe 'issue attribute' do
    let(:representative) do
      Representative.create!(
        name: 'Jane Doe',
        ocdid: 'ocd-456',
        title: 'Representative'
      )
    end
    it 'stores an issue for a news item' do
      news_item = described_class.create!(
        representative: representative,
        title: 'Climate Article',
        link: 'https://example.com/climate',
        description: 'An article about climate change',
        issue: 'Climate Change'
      )
      expect(news_item.reload.issue).to eq('Climate Change')
    end
  end
end
