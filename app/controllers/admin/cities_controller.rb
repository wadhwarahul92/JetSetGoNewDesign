class Admin::CitiesController < Admin::BaseController

  before_filter :authenticate_admin

  def index

  end

end