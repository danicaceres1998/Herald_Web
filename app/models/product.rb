class Product < ApplicationRecord
  belongs_to :brand
  validates :product_id, presence: true
  validates :product_name, presence: true
end