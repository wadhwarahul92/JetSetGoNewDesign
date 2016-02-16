class Organisations::BaseController < ApplicationController

  layout 'organisations'

  after_filter :set_csrf_cookie_for_ng

  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  def authenticate_operator
    if current_user.present? and current_user.operator?
      #do nothing
    else
      redirect_to '/organisations/sign_in'
    end
  end

  def authenticate_no_user
    if current_user.present? and current_user.operator?
      redirect_to '/organisations'
    else
      sign_out(current_user) if current_user.present?
      # do nothing
    end
  end

  helper_method def current_organisation
    @current_organisation ||= current_user.organisation
  end

  protected

  # In Rails 4.2 and above
  def verified_request?
    super || valid_authenticity_token?(session, request.headers['X-XSRF-TOKEN'])
  end

end