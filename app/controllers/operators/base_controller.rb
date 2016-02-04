class Operators::BaseController < ApplicationController

  layout 'operators'

  after_filter :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def authenticate_operator
    if current_user.present? and current_user.operator?
      #do nothing
    else
      redirect_to operators_sign_in_path
    end
  end

  def authenticate_no_user
    if current_user.present? and current_user.operator?
      redirect_to '/operators'
    else
      sign_out(current_user) if current_user.present?
      # do nothing
    end
  end

  protected

  # In Rails 4.2 and above
  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end

end