class OrderDetail < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product
end
