class Product < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  mount_uploader :photo, PhotoUploader

  ratyrate_rateable "quality"

  belongs_to :category
  has_many :order_details, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :name, presence: true, uniqueness: true, length: {maximum: 100}
  validates :code, presence: true, uniqueness: true
  validates :price, presence: true, numericality: {greater_than: 0}
  validates :in_stock, presence: true,
    numericality: {only_integer: true, greater_than_or_equal_to: 0}

  scope :in_category, -> category_id do
    where category_id: category_id if category_id.present?
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def create_code
    prefix_code = Settings.admin.product.prefix_code
    last_record = Product.last
    self[:code] =
      last_record.nil? ? "#{prefix_code}.1" : "#{prefix_code}.#{last_record.id + 1}"
  end

  def self.hot_trend
    date = Settings.period_date.days.ago
    product_ids = "select order_details.product_id
       from order_details
       where (date(order_details.created_at) > '#{date}')
       group by order_details.product_id
       order by sum(order_details.quantity)"
    Product.where("id IN (#{product_ids})")
  end

  def self.most_like
    limit = Settings.most_like_limit
    product_ids = "select likes.product_id
       from likes
       group by likes.product_id
       order by count(likes.product_id)
       limit #{limit}"
    Product.where("id IN (#{product_ids})")
  end
end
