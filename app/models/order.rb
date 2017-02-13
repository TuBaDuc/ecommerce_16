class Order < ApplicationRecord
  require "csv"

  belongs_to :user
  has_many :order_details
  delegate :name, to: :user, prefix: true
  delegate :phone, to: :user, prefix: true

  before_create :set_status, :set_code
  validates :ship_address, presence: true

  enum status: [:in_progress, :shipping, :delivered, :cancel]

  scope :monthly_order, -> start_date, end_date do
    where ("date(updated_at) >= '#{start_date}' AND
      date(updated_at) =< '#{end_date})'")
  end

  def self.to_csv records = [], options = {}
    CSV.generate options do |csv|
      csv << [I18n.t("admin.orders.csv.id"), I18n.t("admin.orders.csv.order_code"),
        I18n.t("admin.orders.csv.status"), I18n.t("admin.orders.csv.total_pay"),
        I18n.t("admin.orders.csv.customer"), I18n.t("admin.orders.csv.ship_address"),
        I18n.t("admin.orders.csv.phone"), I18n.t("admin.orders.csv.created_at"),
        I18n.t("admin.orders.csv.updated_at")]
      records.each do |order|
        csv << [order.id, order.code, order.status, order.total_bill, order.user_name,
          order.ship_address, order.contact_phone, order.created_at, order.updated_at]
      end
    end
  end

  def update_order! session_cart, address, phone
    product_carts = session_cart.map do |id, cart_params|
      [Product.find_by(id: id), cart_params]
    end
    ActiveRecord::Base.transaction do
      begin
        self.update_attributes! ship_address: address,
          total_bill: ApplicationController.helpers.calc_total_pay(product_carts),
          contact_phone: phone

        session_cart.keys.each do |item|
          quantity = session_cart[item]["quantity"].to_i
          product_in_order = Product.find_by id: item.to_i
          remain_quantity = product_in_order.in_stock - quantity
          product_in_order.update_attributes! in_stock: remain_quantity
          price = ApplicationController.helpers
            .calc_total_price_for product_in_order, quantity
          self.order_details.create! quantity: quantity,
            product_id: item.to_i, price: price
        end

        session_cart.clear
      rescue ActiveRecord::RecordInvalid
      end
    end
  end

  private
  def set_status
    self[:status] = :in_progress
  end

  def set_code
    self[:code] = "#{Settings.order_prefix}#{rand(1..99999)}" <<
      Time.now.strftime(Settings.order_time_format)
  end
end
