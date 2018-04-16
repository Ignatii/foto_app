require 'active_interaction'
# add functionality to show sorted images
class ApiFindUsers < ActiveInteraction::Base
  def execute
    ids = User.all.includes(:images).group('users.id').sum('images.likes_count')
    users = User.where("id in (#{ids.keys.join(',')})")
    return errors.add(:base, 'No such users') if users.nil
    users
  end
end
