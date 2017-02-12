class ProductsController < ApplicationController
  load_and_authorize_resource find_by: :slug

  def index
    if session[:recent]
      @recent_products = session[:recent]
        .map{|id| Product.find_by(id: id)}.reverse
    end
    @newest_products = Product.order(created_at: :desc).
      limit Settings.show_limit.show_8
    @hot_trend_products = Product.hot_trend.limit Settings.show_limit.show_8
    @carousel = Product.most_like
  end

  def show
    @comments = @product.comments.order(created_at: :desc)
    session[:recent] = [] unless session[:recent]
    if session[:recent].length > Settings.recent_items_limit
      session[:recent].delete_at(0)
    end
    session[:recent].push @product.id unless session[:recent].include? @product.id
  end
end
