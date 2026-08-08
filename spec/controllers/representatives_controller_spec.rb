require 'rails_helper'
RSpec.describe RepresentativesController, type: :controller do
  describe 'GET #index' do
    it 'gets the representatives index' do
      get :index
      expect(response).to be_successful
    end
  end
end