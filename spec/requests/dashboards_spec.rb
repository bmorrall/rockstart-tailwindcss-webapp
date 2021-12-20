# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboards', type: :request do
  describe 'GET /dashboard' do
    context 'with a guest' do
      it 'redirects to the sign in page' do
        get dashboard_path

        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with a new auth0 user' do
      before { sign_in_as_new_auth0_user }

      it 'renders the dashboard' do
        get dashboard_path

        expect(response).to be_successful
      end
    end
  end
end
