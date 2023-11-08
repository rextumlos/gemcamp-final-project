class Address::Barangay < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :city
  has_many :posts

  def self.table_name_prefix
    "address_"
  end
end