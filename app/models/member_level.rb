class MemberLevel < ApplicationRecord
  validates :level, presence: true
  validates :required_members, presence: true
  validates :coins, presence: true

  has_many :users
end
