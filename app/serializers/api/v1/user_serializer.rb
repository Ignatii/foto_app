# serializer for users in API
class Api::V1::UserSerializer < Api::V1::BaseSerializer
  attributes :id, :email, :name

  has_many :images
  has_many :comments
end
