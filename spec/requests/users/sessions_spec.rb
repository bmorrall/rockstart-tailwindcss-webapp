# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users::Sessions', type: :request do
  describe 'GET /sign_in' do
    it 'renders a sign page with an auth0 link' do
      get new_user_session_path

      expect(response.body).to include user_auth0_omniauth_authorize_path
    end
  end

  describe 'DELETE /sign_out' do
    it 'signs a user out' do
      sign_in_as_new_auth0_user

      delete destroy_user_session_path

      expect(response.body).to redirect_to root_path
    end
  end
end
