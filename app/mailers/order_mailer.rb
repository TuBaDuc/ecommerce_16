class OrderMailer < ApplicationMailer
  def order_finish order, customer
    @order = order
    mail to: customer.email, subject: t("order_finish")
  end
end
