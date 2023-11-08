class Address::Province < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  has_many :cities
  has_many :addresses
  belongs_to :region
  def self.table_name_prefix
    "address_"
  end
end