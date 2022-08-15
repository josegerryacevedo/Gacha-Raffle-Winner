class Category < ApplicationRecord
  validates_presence_of :name
  has_many :items, dependent: :restrict_with_error

  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end