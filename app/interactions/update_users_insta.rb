require 'active_interaction'
# add functionality to show needed images
class UpdateUsersInsta < ActiveInteraction::Base 
  object :user, class: '::User'
  string :token_insta

  validates :user, presence: true
  validates :token_insta, presence: true

  def execute
    return false if token_insta.split('en=')[1].nil?
    if user.update_attributes(insta_token: token_insta.split('en=')[1])
      true
    else
      false
    end
  end
end
