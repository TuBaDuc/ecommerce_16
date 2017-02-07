class Admin::ProductsController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
    params[:limit] ||= Settings.admin.user.page_items_limit.level2
    @search = Product.ransack params[:q]
    @q = Product.search params[:q]
    @products = @q.result(distinct: true).includes(:category)
      .in_category(params[:category_id]).page(params[:page])
      .per params[:limit].to_i
  end
end
