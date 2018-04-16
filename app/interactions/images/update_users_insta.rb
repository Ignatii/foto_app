# require 'active_interaction'
# add functionality to show needed images
module Images
  class UpdateUsersInsta < ActiveInteraction::Base
    object :user, class: '::User'
    string :token_insta

    validates :user, presence: true
    validates :token_insta, presence: true
    validate :check_token_split

    def execute
      upd_insta_tok = user.update(insta_token: token_insta.split('en=')[1])
      return 'Your photos from instagram successfully added' if upd_insta_tok
    end

    private

    def check_token_split
      message = 'Problem with adding your instagram photos.Try later or contact admin'
      return errors.add(:base, message) if token_insta.split('en=')[1].nil?
    end
  end
end
