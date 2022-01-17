# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    layout 'pages'
  end
end
