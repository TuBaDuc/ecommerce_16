class CategoriesController < ApplicationController
  load_resource

  def show
    @search = @category.products.ransack params[:q]
    @q = @category.products.search params[:q]
    @products = @q.result(distinct: true).page(params[:page])
      .per Settings.admin.user.page_items_limit.level2
  end
end
