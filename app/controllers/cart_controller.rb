class CartController < ApplicationController
  def index
    @cart = session[:cart] ? session[:cart] : {}
    @product_carts = @cart.map do |id, cart_params|
      [Product.find_by(id: id), cart_params]
    end
  end

  def create
    product_id = params["product_id"]
    product_name = params["product_name"]
    product_image_url = params["image_url"]
    session[:cart] = {} unless session[:cart]
    cart = session[:cart]
    if cart[product_id]
      cart[product_id]["quantity"] = cart[product_id]["quantity"].to_i + 1
    else
      quantity = 1
      cart[product_id] = {
        "quantity" => quantity, "name" => product_name, "image_url" => product_image_url}
    end
    respond_to do |format|
      format.html{render partial: "cart_item", locals: {cart: cart}}
    end
  end

  def update
    data = params["cart"]
    data.each{|key, value| session[:cart][key][:quantity] = value}
    redirect_to new_order_path
  end

  def destroy
    session[:cart][params[:id]] = nil
    session[:cart].delete_if{|_key, value| value.blank?}
    redirect_to action: :index
  end
end
