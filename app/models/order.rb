class Order < ApplicationRecord
  validates :amount, presence: true, if: :deposit?
  validates :coin, presence: true
  validates :remarks, presence: true, unless: :deposit?
  validates :amount, presence: true, if: :deposit?  # Ensure presence of amount for deposit orders
  validates :amount, numericality: { greater_than: 0 }, if: -> { deposit? && amount.present? } # Ensure amount is greater than 0 for deposit orders
  validates :offer, presence: true, if: :deposit?
  after_create :assign_serial_number

  enum genre: { deposit: 0, increase: 1, deduct: 2, bonus: 3, share: 4 }

  belongs_to :user
  belongs_to :offer, optional: true

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :cancel do
      transitions from: [:pending, :submitted, :paid], to: :cancelled,
                  guard: [:has_enough_coins?],
                  after: :return_coins
    end

    event :pay, after_commit: :is_enough_coins_to_deduct? do
      transitions from: [:pending, :submitted], to: :paid,
                  guard: [:is_deposit?],
                  after: [:increase_user_coins, :decrease_user_coins, :increase_total_deposit]
    end
  end

  private

  def assign_serial_number
    number_count = user.orders.count.to_s.rjust(4, '0')
    update(serial_number: "#{Time.current.to_i}-#{id}-#{user_id}-#{number_count}")
  end

  def increase_user_coins
    unless deduct?
      user.update(coins: user.coins + coin)
    end
  end

  def decrease_user_coins
    if deduct? && user.coins >= coin
      user.update(coins: user.coins - coin)
    end
  end

  def is_enough_coins_to_deduct?
    if deduct? && user.coins < coin
      errors.add(:base, 'User does not have enough coins.')
      cancel!
    end
  end

  def increase_total_deposit
    if deposit?
      user.update(total_deposit: user.total_deposit + amount)
    end
  end

  def return_coins
    if paid?
      unless deduct?
        user.update(coins: user.coins - coin)
      end
    end
  end

  def has_enough_coins?
    return true if submitted? || pending? || deduct?
    return true if user.coins >= coin
    errors.add(:base, 'User does not have enough coins.')
    false
  end

  def is_deposit?
    return true unless pending? && deposit?
    errors.add(:base, 'Cannot transition from pending to paid for deposit orders')
    false
  end

end



