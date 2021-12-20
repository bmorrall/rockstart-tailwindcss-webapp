# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pages', type: :request do
  describe 'GET /' do
    context 'with a guest' do
      it 'responds with success' do
        get root_path

        expect(response).to be_successful
      end
    end

    context 'with a new auth0 user' do
      before { sign_in_as_new_auth0_user }

      it 'redirects to the dashboard' do
        get root_path

        expect(response).to redirect_to dashboard_path
      end
    end
  end
end
