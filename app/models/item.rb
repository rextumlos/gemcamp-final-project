class Item < ApplicationRecord
  validates :name, presence: true
  validates :quantity, presence: true
  validates :minimum_tickets, presence: true
  validates :batch_count, presence: true

  mount_uploader :image, ImageUploader
  enum status: { inactive: 0, active: 1 }

  default_scope { where(deleted_at: nil) }

  has_many :item_category_ships
  has_many :categories, through: :item_category_ships

  def destroy
    update(deleted_at: Time.current)
  end

  include AASM
  aasm column :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from :pending, to: :starting, guard: [:quantity_enough?, :present_day_less_than_offline_at?, :is_item_active?], after: [:deduct_quantity, :increase_batch_count]
    end

    event :pause do
      transitions from :starting, to: :paused
    end

    event :end do
      transitions from :starting, to: :ended
    end

    event :cancel do
      transitions from :starting, to: :cancelled
    end

    # Not final
    event :retry do
      transitions from [:ended, :cancelled], to: :starting, guard: [:quantity_enough?, :present_day_less_than_offline_at?, :is_item_active?]
    end

    def deduct_quantity
      item.update(quantity: item.quantity - 1)
    end

    # Ask if batch_count is default at 0
    def increase_batch_count
      item.update(batch_count: item.batch_count + 1)
    end

    def quantity_enough?
      item.quantity.positive?
    end

    # Ask how offline_at, online_at, start_at works
    def present_day_less_than_offline_at?
      Time.current < item.offline_at
    end

    # Ask how status works
    def is_item_active?
      item.active?
    end
  end
end
