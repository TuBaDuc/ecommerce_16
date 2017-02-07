class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
  def configure_permitted_parameters
    param_attrs = [:name, :email, :password, :current_password,
      :address, :phone, :photo]
    devise_parameter_sanitizer.permit :sign_up, keys: param_attrs
    devise_parameter_sanitizer.permit :account_update, keys: param_attrs
  end
end
