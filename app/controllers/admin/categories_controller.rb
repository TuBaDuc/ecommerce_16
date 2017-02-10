class Admin::CategoriesController < ApplicationController
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
end
