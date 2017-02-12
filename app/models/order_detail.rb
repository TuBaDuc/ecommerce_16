class OrderDetail < ApplicationRecord
  belongs_to :order, optional: true
  belongs_to :product

  delegate :name, to: :product, prefix: true, allow_nil: true
end
