# require 'active_interaction'
# add functionality to show sorted images
module Api
  class FindUser < ActiveInteraction::Base
    string :api_token

    validates :api_token, presence: true

    def execute
      user = User.find_by(api_token: api_token)
      return errors.add(:base, 'No such user with this token') if user.nil
      user
    end
  end
end
