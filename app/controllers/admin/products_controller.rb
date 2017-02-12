class Admin::ProductsController < ApplicationController
  load_and_authorize_resource except: :create, find_by: :slug
  before_action :authenticate_user!, :verify_admin
  protect_from_forgery except: :create

  def index
    params[:limit] ||= Settings.admin.user.page_items_limit.level2
    if params[:q].nil?
      params[:q] = {
        "order_code_or_user_name_cont" => params[:order_code_or_user_name_cont],
        "status_eq" => params[:status_eq]
      }
    end
    @search = Order.ransack params[:q]
    @q = Order.search params[:q]
    @orders_all = @q.result(distinct: true).order_by_updated_time
    respond_to do |format|
      format.html do
        @orders = @orders_all.page(params[:page]).per params[:limit].to_i
      end
      format.xls {send_data Order.to_xls @orders_all}
    end
  end

  def new
  end

  def edit
  end

  def update
    if @product.update_attributes product_params
      flash[:success] = t ".msg_update_success"
    else
      flash[:danger] = t ".msg_update_fail"
    end
    redirect_back fallback_location: :back
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = t ".msg_create_success"
    else
      flash[:danger] = t ".msg_create_fail"
    end
    redirect_back fallback_location: :back
  end

  def destroy
    if @product.order_details.any?
      flash[:danger] = t ".msg_has_been_ordered"
    elsif @product.destroy
      flash[:success] = t ".msg_destroy_success"
    else
      flash[:danger] = t ".msg_destroy_fail"
    end
    redirect_back fallback_location: :back
  end

  private
  def product_params
    params.require(:product).permit :code, :category_id, :name, :photo,
      :price, :in_stock, :description
  end
end
