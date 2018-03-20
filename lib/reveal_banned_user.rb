# add functionality to find banned users
module RevealBannedUser
  extend User

# def banned
#   if current_user[:banned_until] < Time.now
#     current_user[:banned_until] = Time.at(0)
#     return false
#   else
#     return true
#   end
# end
end
User.send(:include, FindByOrderedIds)
