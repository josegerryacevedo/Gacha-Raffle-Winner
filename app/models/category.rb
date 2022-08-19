class Category < ApplicationRecord
  validates_presence_of :name
  has_many :items

  default_scope { where(deleted_at: nil) }

  def destroy
    unless items.present?
    update(deleted_at: Time.current)
    end
  end
end