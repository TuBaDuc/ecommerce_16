class Order < ApplicationRecord
  require "csv"

  belongs_to :user
  has_many :order_details
  delegate :name, to: :user, prefix: true
  delegate :phone, to: :user, prefix: true

  enum status: [:in_progress, :shipping, :delivered, :cancel]

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
end
