# frozen_string_literal: true

class PagesController < ApplicationController
  include HighVoltage::StaticPage

  before_action :redirect_to_dashboard, only: :home, if: :user_signed_in?

  layout 'pages'

  private

  def redirect_to_dashboard
    redirect_to dashboard_path
  end
end
