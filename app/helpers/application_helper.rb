module ApplicationHelper
  def full_title page_title = ""
    system_name = t(:system_name)
    if page_title.empty?
      system_name
    else
      page_title + " | " + system_name
    end
  end

  def set_index_number counter, page, limit
    (page - 1) * limit + counter + 1
  end

  def calc_total_price_for product, quantity
    (product.price * quantity.to_i).round(2)
  end

  def calc_total_pay products
    total_pay = 0.0
    products.each do |product, in_cart|
      total_pay += calc_total_price_for product, in_cart["quantity"]
    end
    total_pay.round(3)
  end
end
