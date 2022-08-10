class Address < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :street_address
  validates_presence_of :is_default, {allow_blank:true}
  validates_presence_of :genre
  validates_presence_of :remark, {allow_blank:true}
  validates :phone_number, phone: true
  belongs_to :user
  belongs_to :region
  belongs_to :province
  belongs_to :city
  belongs_to :barangay
  before_create :default
  before_destroy :destroy_validation
  after_commit :one_default
  validate :limit_address, on: :create

  enum genre: [:home, :office]

  def default
    unless self.user.addresses.present?
      self.is_default = true
    end
  end

  def destroy_validation
    if is_default
      throw(:abort)
    end
  end

  def one_default
    if is_default
      self.user.addresses.where("id != ?", self.id).update_all(is_default: false)
    end
  end

  def limit_address
    return unless self.user
    if self.user.addresses.reload.count > 4
      errors.add(:base, "You reach the limit")
    end
  end
end

