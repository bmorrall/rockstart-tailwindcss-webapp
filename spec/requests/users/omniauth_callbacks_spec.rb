# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users::OmniauthCallbacks', type: :request do
  describe 'POST /users/omniauth/auth0' do
    context 'with valid auth0 credentials' do
      it 'signs in and redirects the user' do
        mock_auth0_hash

        post user_auth0_omniauth_authorize_path
        follow_redirect!

        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid auth0 credentials' do
      before do
        mock_auth0_hash
        OmniAuth.config.mock_auth[:auth0] = :invalid_credentials
      end

      it 'aborts the authentication process', :aggregate_failures do
        post user_auth0_omniauth_authorize_path
        follow_redirect!

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
