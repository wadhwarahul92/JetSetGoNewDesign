class Operators::BaseController < ApplicationController

  layout 'operators'

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

end