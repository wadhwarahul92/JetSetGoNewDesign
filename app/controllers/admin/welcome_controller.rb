class Admin::WelcomeController < Admin::BaseController

  before_filter :authenticate_admin, only: [:dashboard]

  before_filter :authenticate_no_admin, only: [:index]

  def index

  end

  def dashboard

  end

end