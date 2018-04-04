require 'active_interaction'
# add functionality to show needed images
class UpdateUsersInsta < ActiveInteraction::Base 
  object :user, class: '::User'
  string :token_insta

  validates :user, presence: true
  validates :token_insta, presence: true

  def execute
    return errors.add(:base, 'Problem with adding your instagram photos. Try later or contact admin') if token_insta.split('en=')[1].nil?
    return 'Your photos from instagram successfully added' if user.update(insta_token: token_insta.split('en=')[1])
  end
end
