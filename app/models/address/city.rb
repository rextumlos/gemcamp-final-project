class Address::City < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :province
  has_many :barangays
  has_many :posts

  def self.table_name_prefix
    "address_"
  end
end