# require 'active_interaction'
# add functionality to show sorted images
module Api
  class FindUsers < ActiveInteraction::Base
    def execute
      ids = User.all.includes(:images).group('users.id').sum('images.likes_count')
      users = User.where(id: ids)
      return errors.add(:base, 'No such users') if users.nil?
      users
    end
  end
end
