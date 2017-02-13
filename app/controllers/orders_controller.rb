class OrdersController < ApplicationController
  before_action :authenticate_user!, :load_user
  before_action :load_cart, :load_order, only: [:create, :new]
  load_resource only: :update

  def index
    params[:limit] ||= Settings.admin.user.page_items_limit.level2
    @search = @user.orders.ransack params[:q]
    @orders = @user.orders.order(created_at: :desc)
      .page(params[:page]).per params[:limit].to_i
  end

  def new
    @product_carts = @session_cart.map do |id, cart_params|
      [Product.find_by(id: id), cart_params]
    end
    @total_pay = ApplicationController.helpers.calc_total_pay @product_carts
  end

  def create
    if @order.update_order! @session_cart, params[:ship_address], params[:phone]
      flash[:success] = t ".orders_create_success"
      OrderMailer.delay.order_finish @order, @user
      redirect_to root_path
    else
      flash[:danger] = t ".order_create_fail"
      redirect_back fallback_location: :back
    end
  end

  def update
    unless order_params.nil?
      if @order.update_attributes order_params
        flash[:success] = t ".order_update_success"
      else
        flash[:notice] = t ".order_update_fail"
      end
      redirect_back fallback_location: :back
    end
  end

  private
  def load_user
    @user = current_user
    if @user.nil?
      flash[:danger] = t :content_not_found_mess
      redirect_to root_url
    end
  end

  def load_order
    @order = @user.orders.build
    if @order.nil?
      flash[:danger] = t :content_not_found_mess
      redirect_to root_url
    end
  end

  def load_cart
    @session_cart = session[:cart]
    if @session_cart.blank?
      flash[:danger] = t :content_not_found_mess
      redirect_to root_url
    end
  end

  def order_params
    params.permit :id, :status
  end
end
