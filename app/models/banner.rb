class Banner < ApplicationRecord
  validates :preview, presence: true
  validates :online_at, presence: true
  validates :offline_at, presence: true
  validate :offline_at_in_future?
  validate :online_at_before_offline_at?
  enum status: { inactive: 0, active: 1 }

  mount_uploader :preview, ImageUploader

  default_scope { where( deleted_at: nil ) }

  def destroy
    update(deleted_at: Time.current)
  end

  private

  def offline_at_in_future?
    return true unless offline_at.present? && offline_at < Time.current
    errors.add(:offline_at, 'must be in the future')
    false
  end

  def online_at_before_offline_at?
    return true unless online_at.present? && online_at <= Time.current && offline_at < online_at
    errors.add(:online_at, 'must be before offline at date')
    false
  end
end
