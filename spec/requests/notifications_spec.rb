# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notification', type: :request do
  describe 'GET /notifications' do
    context 'with a new auth0 user' do
      before { sign_in_as_new_auth0_user }

      it 'renders the notifications page' do
        get notifications_path

        expect(response).to be_successful
      end
    end

    context 'with a guest' do
      it 'redirects to the sign in page' do
        get notifications_path

        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
