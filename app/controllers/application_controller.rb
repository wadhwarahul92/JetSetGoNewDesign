class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def after_sign_out_path_for(resource_or_scope)
    if resource_or_scope.respond_to?(:admin?) and resource_or_scope.admin?
      admin_path
    else
      params[:redirect_to] ||  root_path
    end
  end
end
