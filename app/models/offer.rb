class Offer < ApplicationRecord
  validates :image, :status, :genre, :coin, :amount, :name, presence: true
  enum status: [:active, :inactive]
  enum genre: [:daily, :one_time, :weekly, :monthly, :regular]

  mount_uploader :image, ImageUploader
end
