# require 'active_interaction'
# add functionality to show needed images
module Images
  class Group < ActiveInteraction::Base
    def execute
      Image.all.joins(:user).group_by(&:user_id)
    end
  end
end
