class Product < ApplicationRecord
  belongs_to :category
  has_many :order_details
  has_many :likes
  has_many :comments
end
