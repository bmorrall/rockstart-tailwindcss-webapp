# frozen_string_literal: true

OmniAuth.config.test_mode = true

module OmniauthMacros
  def sign_in_as_new_auth0_user
    mock_auth0_hash

    post user_auth0_omniauth_authorize_path
    follow_redirect!

    User.find_by!(provider: 'auth0', uid: '123545')
  end

  def mock_auth0_hash
    # The mock_auth configuration allows you to set per-provider (or default)
    # authentication hashes to return during integration testing.
    OmniAuth.config.add_mock(:auth0, {
                               'provider' => 'auth0',
                               'uid' => '123545',
                               'user_info' => {
                                 'name' => 'Mock User',
                                 'image' => 'mock_user_thumbnail_url'
                               },
                               'credentials' => {
                                 'token' => 'mock_token',
                                 'secret' => 'mock_secret'
                               }
                             })
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]
  end
end

RSpec.configure do |config|
  config.include OmniauthMacros, type: :request

  config.before(:each, type: :request) do
    # Use user devise mappings
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user] # If using Devise
  end
end
