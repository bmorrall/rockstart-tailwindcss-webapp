# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    OAUTH_PROVIDERS = Rails.application.config.oauth_providers

    skip_before_action :verify_authenticity_token, only: OAUTH_PROVIDERS

    OAUTH_PROVIDERS.each do |oauth_provider|
      define_method oauth_provider do
        oauth_callback OmniAuth::Utils.camelize(oauth_provider.to_s)
      end
    end

    def failure
      redirect_to new_user_session_path
    end

    private

    def oauth_callback(oauth_provider_name)
      @user = User.from_omniauth(request.env['omniauth.auth'])

      sign_in_and_redirect @user, event: :authentication

      set_flash_message(:notice, :success, kind: oauth_provider_name) if is_navigational_format?
    end
  end
end
