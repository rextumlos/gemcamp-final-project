class MemberLevel < ApplicationRecord
  validates :level, presence: true
  validates :required_members, presence: true
  validates :coins, presence: true

  belongs_to :user, optional: true
end
