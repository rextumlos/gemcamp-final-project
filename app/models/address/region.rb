class Address::Region < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true
  validates :region_name, presence: true

  has_many :provinces
  has_many :posts
end