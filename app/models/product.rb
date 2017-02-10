class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  belongs_to :category
  has_many :order_details
  has_many :likes
  has_many :comments

  validates :name, presence: true, uniqueness: true, length: {maximum: 100}
  validates :code, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {greater_than: 1000}
  validates :in_stock, presence: true,
    numericality: {only_integer: true, greater_than_or_equal_to: 0}

  scope :in_category, -> category_id do
    where category_id: category_id if category_id.present?
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  private
  def create_code
    category_code = "#{self.category.name.first(3).upcase}.#{self.category.id}"
    last_record = Product.last
    self[:code] =
      last_record.nil? ? "#{category_code}.1" : "#{category_code}.#{last_record.id + 1}"
  end
end
