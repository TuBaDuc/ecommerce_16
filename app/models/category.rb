class Category < ApplicationRecord
  acts_as_nested_set
  has_many :products
  has_many :suggests

  validates :name, presence: true, uniqueness: true, allow_blank: false

  delegate :size, to: :products, prefix: :products, allow_nil: true
end
