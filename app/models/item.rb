class Item < ApplicationRecord
  validates :image, :name, :quantity, :minimum_bets, :state, :online_at, :offline_at, :start_at, :status, presence: true

  belongs_to :category

  mount_uploader :image, ImageUploader

  enum status: [:active, :inactive]

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end

  include AASM
  aasm column: :state do
    state :pending, initial: true
    state :starting, :paused, :ended, :cancelled

    event :start do
      transitions from: [:pending, :ended, :cancelled], to: :starting, after: :batch_quantity, guards: [:greater_than_zero?, :future?, :active?]
      transitions from: :paused, to: :starting
    end

    event :pause do
      transitions from: :starting, to: :paused
    end

    event :end do
      transitions from: :starting, to: :ended
    end

    event :cancel, after: :add_quantity do
      transitions from: [:starting, :paused], to: :cancelled
    end
  end

  def add_quantity
    @add_quantity = self.quantity + 1
    update(quantity: @add_quantity)
  end

  def batch_quantity
    @quantity = self.quantity - 1
    @batch_count = self.batch_count + 1
    update(quantity: @quantity, batch_count: @batch_count)
  end

  def greater_than_zero?
    quantity > 0
  end

  def future?
    Time.now < offline_at
  end
end
