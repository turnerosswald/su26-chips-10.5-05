# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController do
  let(:existing_user) do
    User.create!(
      uid: '1', provider: User.providers[:google_oauth2],
      first_name: 'A', last_name: 'B', email: 'a@b.com'
    )
  end

  let(:google_auth) do
    { 'provider' => 'google_oauth2', 'uid' => '12345',
      'info' => { 'first_name' => 'Jane', 'last_name' => 'Doe', 'email' => 'jane@example.com' } }
  end

  let(:github_auth) do
    { 'provider' => 'github', 'uid' => '999',
      'info' => { 'name' => 'John Smith', 'email' => 'john@example.com' } }
  end

  let(:github_auth_no_name) do
    { 'provider' => 'github', 'uid' => '888',
      'info' => { 'name' => nil, 'email' => 'noname@example.com' } }
  end

  describe 'GET new' do
    it 'renders when not logged in' do
      get :new
      expect(response).to have_http_status(:ok)
    end

    it 'redirects when already logged in' do
      session[:user_id] = existing_user.id
      get :new
      expect(response).to redirect_to(user_profile_path)
    end
  end

  describe 'POST create' do
    it 'creates a new user with google and logs them in' do
      request.env['omniauth.auth'] = google_auth
      expect { post :create, params: { provider: 'google_oauth2' } }.to change(User, :count).by(1)
      expect(session[:user_id]).to eq(User.last.id)
    end

    it 'splits a github name into first and last' do
      request.env['omniauth.auth'] = github_auth
      post :create, params: { provider: 'github' }
      user = User.find_by(uid: '999', provider: User.providers[:github])
      expect(user.first_name).to eq('John')
      expect(user.last_name).to eq('Smith')
    end

    it 'defaults to GitHub User when github gives no name' do
      request.env['omniauth.auth'] = github_auth_no_name
      post :create, params: { provider: 'github' }
      user = User.find_by(uid: '888', provider: User.providers[:github])
      expect(user.first_name).to eq('GitHub')
      expect(user.last_name).to eq('User')
    end
  end

  describe 'DELETE destroy' do
    it 'resets the session and redirects to root' do
      session[:user_id] = 1
      delete :destroy
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET omniauth_failure' do
    it 'redirects to root with an alert' do
      get :omniauth_failure, params: { message: 'oops' }
      expect(response).to redirect_to(root_url)
      expect(flash[:alert]).to eq('Login failed unexpectedly. (oops)')
    end
  end
end
