class Admin::UsersController < ApplicationController
  before_action :authenticate_user!, :verify_admin
  before_action :load_user, only: [:destroy]

  def index
    params[:limit] ||= Settings.admin.user.page_items_limit.level1
    @search = User.ransack params[:q]
    @q = User.search params[:q]
    @users = @q.result(distinct: true)
      .order_by_name_desc.page(params[:page]).per params[:limit].to_i
  end

  def destroy
    if @user.orders.any? or @user.suggests.any?
      flash[:danger] = t ".msg_cant_detroy"
    elsif @user.destroy
      flash[:success] = t ".msg_detroy_success"
    else
      flash[:danger] = t ".msg_detroy_fail"
    end
    redirect_back fallback_location: :back
  end
end
