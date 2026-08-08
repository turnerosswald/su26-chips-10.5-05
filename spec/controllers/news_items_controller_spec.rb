# frozen_string_literal: true

require 'rails_helper'
describe MyNewsItemsController do
  before do
    allow(controller).to receive(:require_login!).and_return(true)
    @representative = Representative.create!(
      name: 'Jane Doe',
      ocdid: 'ocd-division/country:us',
      title: 'Senator',
      party: 'Independent')
    @other_representative = Representative.create!(
      name: 'John Smith',
      ocdid: 'ocd-division/country:us/state:ca',
      title: 'Representative',
      party: 'Independent')
    @news_item = NewsItem.create!(
      title: 'Existing News',
      issue: 'Healthcare',
      description: 'Existing description',
      link: 'https://example.com/existing',
      representative: @representative)
  end
  describe 'GET new' do
    it 'returns a successful response' do
      get :new, params: { representative_id: @representative.id }
      expect(response).to be_successful
    end
    it 'creates a new news item' do
      get :new, params: { representative_id: @representative.id }
      expect(assigns(:news_item)).to be_a_new(NewsItem)
    end
    it 'assigns the representative' do
      get :new, params: { representative_id: @representative.id }
      expect(assigns(:representative)).to eq(@representative)
    end
    it 'assigns the representatives list' do
      get :new, params: { representative_id: @representative.id }

      expect(assigns(:representatives_list)).to include(
        [@representative.name, @representative.id],
        [@other_representative.name, @other_representative.id])
    end
  end
  describe 'GET edit' do
    it 'returns a successful response' do
      get :edit,
          params: {
            representative_id: @representative.id,
            id: @news_item.id}
      expect(response).to be_successful
    end
    it 'assigns the requested news item' do
      get :edit,
          params: {
            representative_id: @representative.id,
            id: @news_item.id}
      expect(assigns(:news_item)).to eq(@news_item)
    end
  end
  describe 'POST create' do
    context 'with valid parameters' do
      it 'creates a new news item' do
        expect do
          post :create,
               params: {
                 representative_id: @representative.id,
                 news_item: {
                   title: 'New Story',
                   issue: 'Education',
                   description: 'New description',
                   link: 'https://example.com/new',
                   representative_id: @representative.id
                 }}
        end.to change(NewsItem, :count).by(1)
      end
      it 'redirects to the created news item' do
        post :create,
             params: {
               representative_id: @representative.id,
               news_item: {
                 title: 'New Story',
                 issue: 'Education',
                 description: 'New description',
                 link: 'https://example.com/new',
                 representative_id: @representative.id}
             }
        created_item = NewsItem.order(:created_at).last
        expect(response).to redirect_to(
          representative_news_item_path(@representative, created_item))
      end
    end
    context 'with invalid parameters' do
      it 'renders the new template' do
        post :create,
             params: {
               representative_id: @representative.id,
               news_item: {
                 title: 'Invalid Story',
                 representative_id: nil}
             }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end
  describe 'PATCH update' do
    context 'with valid parameters' do
      it 'updates the news item' do
        patch :update,
              params: {
                representative_id: @representative.id,
                id: @news_item.id,
                news_item: {
                  title: 'Updated News',
                  issue: @news_item.issue,
                  description: @news_item.description,
                  link: @news_item.link,
                  representative_id: @representative.id}
              }
        expect(@news_item.reload.title).to eq('Updated News')
      end
      it 'redirects to the news item' do
        patch :update,
              params: {
                representative_id: @representative.id,
                id: @news_item.id,
                news_item: {
                  title: 'Updated News',
                  issue: @news_item.issue,
                  description: @news_item.description,
                  link: @news_item.link,
                  representative_id: @representative.id}
              }
        expect(response).to redirect_to(
          representative_news_item_path(@representative, @news_item))
      end
    end
    context 'with invalid parameters' do
      it 'renders the edit template' do
        patch :update,
              params: {
                representative_id: @representative.id,
                id: @news_item.id,
                news_item:{
                  representative_id: nil}
              }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end
  describe 'DELETE destroy' do
    it 'deletes the news item' do
      expect do
        delete :destroy,
               params: {
                 representative_id: @representative.id,
                 id: @news_item.id}
      end.to change(NewsItem, :count).by(-1)
    end
    it 'redirects to the representative news items page' do
      delete :destroy,
             params: {
               representative_id: @representative.id,
               id: @news_item.id
             }
      expect(response).to redirect_to(
        representative_news_items_path(@representative))
    end
  end
end