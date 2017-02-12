class Admin::SuggestsController < ApplicationController
  load_and_authorize_resource except: [:update]
  before_action :authenticate_user!, :verify_admin
  before_action :load_suggest, only: [:update]

  def index
    params[:limit] ||= Settings.admin.user.page_items_limit.level1
    @search = Suggest.ransack params[:q]
    @q = Suggest.search params[:q]
    @suggests = @q.result(distinct: true)
      .order(created_at: :desc).page(params[:page]).per params[:limit].to_i
  end

  def update
    unless suggest_params.nil?
      if @suggest.update_attributes suggest_params
        flash[:success] = t ".msg_update_success"
      else
        flash[:notice] = t ".msg_update_fail"
      end
      redirect_back fallback_location: :back
    end
  end

  private
  def suggest_params
    params.permit :status
  end

  def load_suggest
    @suggest = Suggest.find_by id: params[:id]
    @suggest ? @suggest : redirect_back(fallback_location: :back)
  end
end
