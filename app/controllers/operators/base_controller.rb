class Operators::BaseController < ApplicationController

  layout 'operators'

  def authenticate_operator
    if current_user.present? and current_user.operator?
      #do nothing
    else
      raise ActionController::InvalidAuthenticityToken
    end
  end

end