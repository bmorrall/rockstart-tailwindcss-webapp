# frozen_string_literal: true

class User < ApplicationRecord
  devise :trackable, :omniauthable, omniauth_providers: Rails.application.config.oauth_providers

  def self.from_omniauth(auth)
    user_from_omniauth = find_or_initialize_by(provider: auth.provider, uid: auth.uid)
    user_from_omniauth.name = auth.info.name
    user_from_omniauth.image = auth.info.image
    user_from_omniauth.tap(&:save!)
  end

  protected

  # [Devise Trackable] Mask all logged IP Addresses
  def extract_ip_from(request)
    IpAnonymizer.mask_ip(request.remote_ip)
  end
end
