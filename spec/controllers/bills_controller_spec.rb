# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BillsController do
  let(:client) { instance_double(Congress::Client) }
  let(:api_response) { instance_double(Congress::Response) }
  let(:result) do
    {
      'bills' => [
        {
          'congress' => 119,
          'number' => '134',
          'originChamber' => 'House',
          'title' => 'Test Bill',
          'type' => 'HR'
        }
      ],
      'pagination' => { 'count' => 1 }
    }
  end

  before do
    allow(Congress::Client).to receive(:new).and_return(client)
    allow(api_response).to receive(:get).and_return(result)
  end

  describe 'GET index' do
    context 'when no search parameters are provided' do
      it 'requests the 50 most recent bills' do
        allow(client).to receive(:bills).with(limit: 50).and_return(api_response)
        get :index
        expect(client).to have_received(:bills).with(limit: 50)
      end
    end

    context 'when only congress is provided' do
      it 'searches bills from that congress' do
        allow(client).to receive(:bills).with(congress: '119').and_return(api_response)
        get :index, params: { congress: '119' }
        expect(client).to have_received(:bills).with(congress: '119')
      end
    end

    context 'when congress and bill type are provided' do
      it 'searches by congress and bill type' do
        allow(client).to receive(:bills).with(congress: '119', type: 'hr').and_return(api_response)
        get :index, params: { congress: '119', bill_type: 'hr' }
        expect(client).to have_received(:bills).with(congress: '119', type: 'hr')
      end
    end

    it 'assigns bills returned by the API' do
      allow(client).to receive(:bills).with(limit: 50).and_return(api_response)
      get :index
      expect(assigns(:bills)).to eq(result['bills'])
    end

    it 'assigns the total result count from API pagination' do
      allow(client).to receive(:bills).with(limit: 50).and_return(api_response)
      get :index
      expect(assigns(:total)).to eq(1)
    end

    context 'when bill type is provided without congress' do
      it 'does not make a congress.gov API request' do
        get :index, params: { bill_type: 'hr' }
        expect(Congress::Client).not_to have_received(:new)
      end

      it 'returns an empty set of bills and displays an alert' do
        get :index, params: { bill_type: 'hr' }
        expect(assigns(:bills)).to eq([])
        expect(assigns(:total)).to eq(0)
        expect(flash[:alert]).to eq('Select a Congress session to search by bill type.')
      end
    end
  end

  describe 'POST create' do
    let(:create_params) do
      {
        title: 'Test Bill',
      congress: '119',
      number: '134',
      bill_type: 'HR',
      original_chamber: 'House'
      }
    end

    before do
      allow(client).to receive(:get).and_return('summaries' => [])
      allow(Bill).to receive(:save_from_api).and_return(nil)
    end

    it 'redirects back to the bills page' do
      post :create, params: create_params

      expect(response).to redirect_to(bills_path)
    end

    it 'displays an alert when the bill cannot be saved' do
      post :create, params: create_params

      expect(flash[:alert]).to eq('Could not save that bill.')
    end
  end
end
