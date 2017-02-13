class Admin::ProductsController < ApplicationController
  load_and_authorize_resource except: :create, find_by: :slug
  before_action :authenticate_user!, :verify_admin
  protect_from_forgery except: :create

  def index
    params[:limit] ||= Settings.admin.user.page_items_limit.level2
     @search = Product.ransack params[:q]
     @q = Product.search params[:q]
     @products = @q.result(distinct: true).includes(:category)
        .in_category(params[:category_id]).page(params[:page])
        .per params[:limit].to_i
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
