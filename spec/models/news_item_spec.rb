# frozen_string_literal: true

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
