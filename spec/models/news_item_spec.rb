require 'rails_helper'
RSpec.describe NewsItem, type: :model do
  describe '.find_for' do
    it 'returns the news item for the representative' do
      representative = Representative.create!(
        name: 'John Doe',
        ocdid: 'ocd-1',
        title: 'Mayor',
        party: 'Independent')
      news_item = NewsItem.create!(
        title: 'New Policy',
        description: 'Description',
        link: 'https://example.com',
        issue: 'Health',
        representative: representative)
      expect(NewsItem.find_for(representative.id)).to eq(news_item)
    end
    it 'returns nil if no news item exists' do
      expect(NewsItem.find_for(-1)).to be_nil
    end
  end
end