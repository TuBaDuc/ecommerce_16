class Admin::OrdersController < ApplicationController
  load_and_authorize_resource except: :index
  before_action :authenticate_user!, :verify_admin

  def index
    params[:limit] ||= Settings.admin.user.page_items_limit.level2
    if params[:q].nil?
      params[:q] = {
        "code_or_user_name_cont" => params[:code_or_user_name_cont],
        "status_eq" => params[:status_eq]
      }
    end
    @search = Order.ransack params[:q]
    @q = Order.search params[:q]
    @orders_all = @q.result(distinct: true).order(updated_at: :desc)
    respond_to do |format|
      format.html do
        @orders = @orders_all.page(params[:page]).per params[:limit].to_i
      end
      format.js
      format.csv do
        send_data Order.to_csv @orders_all
        headers["Content-Disposition"] = "attachment; \
          filename=\"orders_#{Time.now.strftime("%Y%m%d%H%M%S")}.csv\""
      end
    end
  end

  def update
    unless order_params.nil?
      if @order.update_attributes order_params
        flash[:success] = t ".msg_update_success"
      else
        flash[:notice] = t ".msg_update_fail"
      end
      redirect_back fallback_location: :back
    end
  end

  private
  def order_params
    params.permit :status
  end
end
