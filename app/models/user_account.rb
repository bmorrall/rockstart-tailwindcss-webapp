# frozen_string_literal: true

class UserAccount < ApplicationRecord
  def self.from_omniauth(auth)
    find_or_initialize_by(provider: auth.provider, uid: auth.uid)
  end

  belongs_to :user, autosave: true
end
