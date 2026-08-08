require 'rails_helper'
RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      require_login!
      head :ok unless performed?
    end
  end
  describe '#require_login!' do
    it 'redirects a user who is not logged in' do
      routes.draw {get 'index' => 'anonymous#index' }
      get :index
      expect(response).to be_redirect
      expect(flash[:notice]).to be_present
    end
  end
end