class Brand < ApplicationRecord
  belongs_to :biller
  has_many :products
  validates :brand_code, presence: true
  validates :brand_name, presence: true
end