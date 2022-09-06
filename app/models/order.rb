class Order < ApplicationRecord
  validates :amount, numericality: { greater_than_or_equal: 0 }
  belongs_to :user
  belongs_to :offer, optional: true
  enum genre: [:deposit, :increase, :deduct, :bonus, :share]
  after_create :generate_serial_number

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :submitted, :cancelled, :paid

    event :submit do
      transitions from: :pending, to: :submitted
    end

    event :pay do
      transitions from: :submitted, to: :paid, guard: :check_user_coin, after: [:pay_change_user_coins, :increase_total_deposit, :check_user_coin]
    end

    event :cancel do
      transitions from: [:pending, :submitted], to: :cancelled
      transitions from: :paid, to: :cancelled, after: [:cancel_change_user_coins, :deduct_total_deposit]
    end
  end

  def pay_change_user_coins
    if deduct?
      user.update(coins: user.coins - coin)
    else
      user.update(coins: user.coins + coin)
    end
  end

  def increase_total_deposit
    user.update(total_deposit: user.total_deposit + amount) if deposit?
  end

  def cancel_change_user_coins
    if deduct?
      user.update(coins: user.coins + coin)
    else
      user.update(coins: user.coins - coin)
    end
  end

  def deduct_total_deposit
    user.update(total_deposit: user.total_deposit - amount) if deposit?
  end

  def check_user_coin
    if (user.coins >= coin) && !deduct?
      true
    else
      error.base(base: 'Not Enough Coin!')
      false
    end
  end

  def generate_serial_number
    ActiveRecord::Base.connection.execute("UPDATE `orders` SET `orders`.`serial_number` = CONCAT(DATE_FORMAT(CONVERT_TZ(orders.created_at, '+00:00', '+8:00'), '%y%m%d'),'-',#{id},'-',#{user.id},'-',
                                                  (SELECT LPAD(count(*), 4, 0)
                                                   FROM `orders` where `orders`.`user_id` = #{user.id}))
                                                   WHERE orders.id = #{id}")
  end
end
