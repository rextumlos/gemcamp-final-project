class Address::Province < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  has_many :cities
  belongs_to :region
  has_many :posts
end