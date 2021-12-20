# frozen_string_literal: true

module UsersHelper
  # Displays the image for a user (with a fallback if required)
  def user_image_tag(user, icon_args = {})
    image_url = user.image || 'http://www.gravatar.com/avatar'
    image_tag(image_url, icon_args.reverse_merge(alt: user.name))
  end
end
