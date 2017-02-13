class CommentsController < ApplicationController
  before_action :authenticate_user!, :load_product, only: [:create, :destroy]

  def create
    @comment = @product.comments.create comment_params
    @comment.user = current_user
    @comments = @product.comments if @comment.save
  end

  def destroy
    @comment = Comment.find_by id: params[:id]
    @comment.destroy unless @comment.nil?
  end

  private
  def comment_params
    params.require(:comment).permit :content
  end

  def load_product
    @product = Product.find_by slug: params[:product_id]
  end
end
