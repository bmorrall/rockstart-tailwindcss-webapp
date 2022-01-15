# frozen_string_literal: true

class User < ApplicationRecord
  devise :trackable, :omniauthable, omniauth_providers: Rails.application.config.oauth_providers

  def self.from_omniauth(auth)
    user_account = UserAccount.from_omniauth(auth)

    user_from_omniauth = user_account.user || user_account.build_user
    user_from_omniauth.name = auth.info.name
    user_from_omniauth.image = auth.info.image
    user_account.save!

    user_from_omniauth
  end

  protected

  # [Devise Trackable] Mask all logged IP Addresses
  def extract_ip_from(request)
    IpAnonymizer.mask_ip(request.remote_ip)
  end
end
