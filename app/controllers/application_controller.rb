class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  after_filter :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def authenticate_user_api
    unless current_user.present?
      render status: :unprocessable_entity, json: {errors: ['Not signed in']}
    end
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope.respond_to?(:admin?) and resource_or_scope.admin?
      admin_path
    else
      params[:redirect_to] || root_path
    end
  end

  def api_user
    @api_user ||= User.where(api_token: params[:api_token]).last
  end

  def current_user
    params[:api_token].present? ? api_user : super
  end

  # In Rails 4.2 and above
  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN']) || from_mobile?
  end

  def from_mobile?
    params[:from_mobile] == 'yes'
  end

end
