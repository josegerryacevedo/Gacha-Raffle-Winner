class Item < ApplicationRecord
  validates :image, :name, :quantity, :minimum_bets, :state, :online_at, :offline_at, :start_at, :status, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  has_many :bets
  belongs_to :category

  mount_uploader :image, ImageUploader

  enum status: [:active, :inactive]

  default_scope { where(deleted_at: nil) }

  def destroy
    unless bets.present?
      update(deleted_at: Time.current)
    end
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, after: :batch_quantity, guards: [:stay_at_zero?, :future?, :active?]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended, after: :random_winner, guards: :greater_than_minimum_bet?
    end

    event :cancel, after: [:cancel_bet, :return_quantity] do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  def return_quantity
    @add_quantity = self.quantity + 1
    update(quantity: @add_quantity)
  end

  def batch_quantity
    @quantity = self.quantity - 1
    @batch_count = self.batch_count + 1
    update(quantity: @quantity, batch_count: @batch_count)
  end

  def stay_at_zero?
    quantity >= 0
  end

  def future?
    offline_at > Time.now
  end

  def cancel_bet
    bets.where(batch_count: batch_count).where.not(state: :cancelled).each { |bet| bet.cancel! }
  end

  def greater_than_minimum_bet?
    bets.where(batch_count: batch_count).betting.count >= minimum_bets
  end

  def random_winner
    bet_item = bets.where(batch_count: batch_count).betting
    winner = bet_item.sample
    winner.win!
    bet_item.where.not(state: :won).each { |bet| bet.lose! }
    store_winner = Winner.new(item_batch_count: winner.batch_count, user: winner.user, item: winner.item, bet: winner, address: winner.user.addresses.find_by(is_default: true))
    store_winner.save!
  end
end
