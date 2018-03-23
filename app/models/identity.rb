# model for identities in app
class Identity < ApplicationRecord
  belongs_to :user

  def self.create_identity(info)
    create(info)
  end
end
