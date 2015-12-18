class Admin::WelcomeController < Admin::BaseController

  before_filter :authenticate_admin, only: [:dashboard]

  before_filter :authenticate_no_admin, only: [:index]

  def index

  end

  def dashboard

  end

  def log_in
    if sign_in_admin
      redirect_to action: :dashboard
    else
      flash[:error] = 'Email/Password combination wrong, contact super admin.'
      render action: :index
    end
  end

  private

  def sign_in_admin
    email = params[:email]
    password = params[:password]
    return false unless email.present? or password.present?
    admin = Admin.where(email: email).first
    return false unless admin.present?
    if admin.valid_password?(password)
      sign_in(admin)
    end
  end

end