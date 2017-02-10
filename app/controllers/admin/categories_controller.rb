class Admin::CategoriesController < ApplicationController
  load_and_authorize_resource
  before_action :authenticate_user!, :verify_admin

  def index
    params[:limit] ||= Settings.admin.user.page_items_limit.level2
    @search = Category.ransack params[:q]
    @q = Category.search params[:q]
    @categories = @q.result(distinct: true).order(:lft)
      .page(params[:page]).per params[:limit].to_i
  end

  def new
  end

  def edit
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t ".msg_create_success"
    else
      flash.now[:danger] = t ".msg_create_fail"
    end
    redirect_back fallback_location: :back
  end

  def update
    if @category.update_attributes category_params
      flash[:success] = t ".msg_update_success"
    else
      flash.now[:danger] = t ".msg_update_fail"
    end
    redirect_back fallback_location: :back
  end

  def destroy
    if !@category.leaf?
      flash[:danger] = t(".msg_delete_fail") + " " + t(".msg_delete_notice_leaf")
    elsif @category.products.any? or @category.suggests.any?
      flash[:danger] = t(".msg_delete_fail") + " " + t(".msg_delete_notice_product")
    elsif @category.destroy
      flash[:success] = t ".msg_delete_success"
    else
      flash[:danger] = t ".msg_delete_fail"
    end
    redirect_back fallback_location: :back
  end

  private
  def category_params
    params.require(:category).permit :parent_id, :name, :description
  end
end
