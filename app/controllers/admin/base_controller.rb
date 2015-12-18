class Admin::BaseController < ApplicationController

  layout 'admin'

  def authenticate_admin
    if current_user and current_user.admin?
      #proceed
    else
      redirect_to admin_path
    end
  end

  def authenticate_no_admin
    if current_user and current_user.admin?
      redirect_to admin_dashboard_path
    end
  end

end