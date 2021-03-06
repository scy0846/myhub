class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :configure_devise_params, if: :devise_controller?
  after_filter :set_csrf_cookie_for_ng
  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected
    def verified_request?
      super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
    end  

  def configure_devise_params
    devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email, :password, :password_confirmation, :remember_me, :username)}
    devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:email, :current_password, :password, :password_confirmation, :remember_me, :username, :avatar)}
  end

  def create
    @user = User.create( user_params )
  end



  private
  # Use strong_parameters for attribute whitelisting
  # Be sure to update your create() and update() controller methods.

  def user_params
    params.require(:user).permit(:avatar, :email, :password, :password_confirmation)
  end

  def posting_params
    params.require(:posting).permit(:content, :id)
  end

  
end
