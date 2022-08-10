class Province < ApplicationRecord
  belongs_to :region
  has_many :cities
  has_many :addresses
end
