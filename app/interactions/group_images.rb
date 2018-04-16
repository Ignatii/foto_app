require 'active_interaction'
# add functionality to show needed images
class GroupImages < ActiveInteraction::Base
  def execute
    users = Image.all.joins(:user).group(:user_id)
    array = []
    users.each do |user|
      array.push(Image.all.select(:id,
                                  :user_id,
                                  :aasm_state,
                                  :likes_count).where(user: user.user))
    end
    array
  end
end
