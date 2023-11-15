class Ticket < ApplicationRecord
  validates :batch_count, presence: true
  validate :user_balance_enough?
  after_create :assign_serial_number 
  after_create :deduct_coin_to_user

  belongs_to :item
  belongs_to :user

  include AASM

  aasm column: :state do
    state :pending, initial: true
    state :won, :lost, :cancelled

    event :win do
      transitions from: :pending, to: :won
    end

    event :lose do
      transitions from: :pending, to: :lost
    end

    event :cancel do
      transitions from: :pending, to: :cancelled, after: :refund_coin
    end
  end

  private

  def assign_serial_number
    number_count = ((check_number_count || 0) + 1).to_s.rjust(4, '0')
  
    update(serial_number: "#{Time.current.to_i}-#{item_id}-#{batch_count}-#{number_count}")
  end
  
  def check_number_count
    last_ticket = Ticket.where(item: item, batch_count: batch_count).last(2).first

    if last_ticket&.serial_number
      last_ticket.serial_number.last(4).to_i
    end
  end

  def user_balance_enough?
    return true if user.coins > 0
    errors.add(:base, 'You do not have enough coins.')
    false
  end

  def deduct_coin_to_user
    user.update(coins: user.coins - 1)
  end

  def refund_coin
    user.update(coins: user.coins + 1)
  end
end