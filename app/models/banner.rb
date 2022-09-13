class Banner < ApplicationRecord
  validates :preview, :online_at, :offline_at, :status, presence: true
  enum status: [:active, :inactive]
  mount_uploader :preview, ImageUploader
  default_scope { where(deleted_at: nil) }

  def destroy
    update(deleted_at: Time.current)
  end
end