# serializer for images in API
class Api::V1::ImageSerializer < Api::V1::BaseSerializer
  attributes :id, :user_id, :aasm_state, :likes_count
  has_many :comments
end
