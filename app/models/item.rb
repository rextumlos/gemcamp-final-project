class Item < ApplicationRecord
  validates :name, presence: true
  validates :quantity, presence: true
  validates :minimum_tickets, presence: true
  validates :batch_count, presence: true

  mount_uploader :image, ImageUploader
  enum status: { inactive: 0, active: 1 }

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end
