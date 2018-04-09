class Country < ApplicationRecord
  has_many :visits, dependent: :destroy
  has_many :users, through: :visits
  accepts_nested_attributes_for :visits, allow_destroy: true
end
