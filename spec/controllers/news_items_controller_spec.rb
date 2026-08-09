# frozen_string_literal: true

require 'rails_helper'

describe NewsItemsController do
  let!(:representative) do
    Representative.create!(
      name: 'Jane Doe',
      ocdid: 'ocd-123',
      title: 'Representative'
    )
  end

  let!(:news_item) do
    NewsItem.create!(
      representative: representative,
      title: 'Test News',
      link: 'https://example.com/news'
    )
  end

  describe 'GET show' do
    it 'assigns the requested news item' do
      get :show, params: { representative_id: representative.id, id: news_item.id }
      expect(assigns(:news_item)).to eq(news_item)
    end
  end
end
