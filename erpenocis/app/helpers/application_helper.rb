module ApplicationHelper
  def user_profile_picture(user, size=40)
    if user.profile_picture.attached?
      user.profile_picture.variant(gravity: "center", resize_to_fill: [size,size])
    else
     gravatar_image_url(user.email, size: size, d: "mp")
    end
  end
end
