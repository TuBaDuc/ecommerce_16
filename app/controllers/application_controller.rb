class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def verify_admin
    redirect_to root_path unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    if @user.nil?
      flash[:danger] = t :content_not_found_mess
      redirect_to root_url
    end
  end

  protected
  def configure_permitted_parameters
    param_attrs = [:name, :email, :password, :current_password,
      :address, :phone, :photo]
    devise_parameter_sanitizer.permit :sign_up, keys: param_attrs
    devise_parameter_sanitizer.permit :account_update, keys: param_attrs
  end
end
