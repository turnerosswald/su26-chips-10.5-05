require 'rails_helper'

RSpec.describe User do
  describe '#name' do
    it 'returns the full name' do
      user = described_class.new(first_name: 'Jane', last_name: 'Doe')
      expect(user.name).to eq('Jane Doe')
    end
  end
  describe '#auth_provider' do
    it 'returns the readable provider name' do
      user = described_class.new(provider: :github)

      expect(user.auth_provider).to eq('GitHub')
    end
  end
  describe '.find_google_user' do
    it 'finds a Google user by uid' do
      user = described_class.create!(
        uid: '123',
        provider: :google_oauth2,
        first_name: 'Jane',
        last_name: 'Doe',
        email: 'jane@example.com'
      )
      expect(described_class.find_google_user('123')).to eq(user)
    end
  end
  describe '.find_github_user' do
    it 'finds a GitHub user by uid' do
      user = described_class.create!(
        uid: '456',
        provider: :github,
        first_name: 'John',
        last_name: 'Smith',
        email: 'john@example.com'
      )
      expect(described_class.find_github_user('456')).to eq(user)
    end
  end
end