class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  validates :phone, phone: true
  mount_uploader :image, ImageUploader

  def client?
    role == 'client'
  end

  def admin?
    role == 'admin'
  end

end
