class Address < ApplicationRecord
  LIMIT = 5
  validates :name, :street_address, :genre, presence: true
  validates_presence_of :is_default, {allow_blank:true}
  validates_presence_of :remark, {allow_blank:true}
  validates :phone_number, phone: true
  belongs_to :user
  belongs_to :region
  belongs_to :province
  belongs_to :city
  belongs_to :barangay
  before_create :first_entry_default
  before_destroy :prevent_default_destroy
  after_commit :one_default_address_only
  validate :limit_address, on: :create

  enum genre: [:home, :office]

  def first_entry_default
    unless user.addresses.present?
      self.is_default = true
    end
  end

  def prevent_default_destroy
    if is_default
      throw(:abort)
    end
  end

  def one_default_address_only
    if is_default
      user.addresses.where.not(id: id).update_all(is_default: false)
    end
  end

  def limit_address
    return unless self.user
    if self.user.addresses.reload.count >= LIMIT
      errors.add(:base, "You reach the limit")
    end
  end
end

