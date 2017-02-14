class CategoriesController < ApplicationController
  load_resource

  def show
    @search = @category.products.ransack params[:q]
    @q = @category.products.search params[:q]
    @products = @q.result(distinct: true).page(params[:page])
      .per Settings.show_limit.show_8
  end
end
