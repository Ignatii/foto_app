# model for identities in app
class Identity < ApplicationRecord
  belongs_to :user

  def create_identity(info)
    Identity.create(info)
  end
end
