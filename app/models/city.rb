class City < ApplicationRecord
  belongs_to :province
  has_many :barangays
  has_many :addresses
end
