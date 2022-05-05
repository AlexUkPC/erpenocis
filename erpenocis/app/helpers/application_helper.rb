module ApplicationHelper
  def user_profile_picture(user, size=40)
    if user.profile_picture.attached?
      user.profile_picture.variant(gravity: "center", resize_to_fill: [size,size])
    else
      profile_picture_url(user.email)
    end
  end
  def profile_picture_url(email)
    hash = Digest::MD5.hexdigest(email)
    "https://www.gravatar.com/avatar/#{hash}?d=mp"
  end
end
