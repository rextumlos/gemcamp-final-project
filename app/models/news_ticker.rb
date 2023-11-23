class NewsTicker < ApplicationRecord
  validates :content, presence: true
  validate :is_user_admin?
  enum status: { inactive: 0, active: 1 }
  belongs_to :admin, class_name: 'User'

  default_scope { where( deleted_at: nil ) }

  def destroy
    update(deleted_at: Time.current)
  end

  private

  def is_user_admin?
    return true if admin.admin?
    errors.add(:base, 'Unauthorized request.')
    false
  end
end
