# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MyNewsItemsController do
  let(:user) do
    User.create!(
      uid: '1', provider: User.providers[:google_oauth2],
      first_name: 'A', last_name: 'B', email: 'a@b.com'
    )
  end

  let(:representative) do
    Representative.create!(name: 'Jane Doe', ocdid: 'ocd-news-test', title: 'Representative')
  end

  let(:news_item) do
    NewsItem.create!(
      representative: representative, title: 'Old Title',
      link: 'https://example.com/old', description: 'Old description'
    )
  end

  before { session[:user_id] = user.id }

  it 'renders new' do
    get :new, params: { representative_id: representative.id }
    expect(response).to have_http_status(:ok)
  end

  it 'renders edit' do
    get :edit, params: { representative_id: representative.id, id: news_item.id }
    expect(response).to have_http_status(:ok)
  end

  it 'creates a news item' do
    params = { title: 'New', link: 'https://example.com', description: 'desc', representative_id: representative.id }
    expect do
      post :create, params: { representative_id: representative.id, news_item: params }
    end.to change(NewsItem, :count).by(1)
    expect(response).to redirect_to(representative_news_item_path(representative, NewsItem.last))
  end

  it 'updates a news item' do
    patch :update, params: { representative_id: representative.id, id: news_item.id,
                              news_item: { title: 'Updated' } }
    expect(news_item.reload.title).to eq('Updated')
    expect(response).to redirect_to(representative_news_item_path(representative, news_item))
  end

  it 'destroys a news item' do
    id = news_item.id
    expect do
      delete :destroy, params: { representative_id: representative.id, id: id }
    end.to change(NewsItem, :count).by(-1)
    expect(response).to redirect_to(representative_news_items_path(representative))
  end
end
