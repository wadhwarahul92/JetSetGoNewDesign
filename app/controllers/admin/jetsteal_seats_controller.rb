class Admin::JetstealSeatsController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_jetsteal

  def index

  end

  private

  def set_jetsteal
    @jetsteal = Jetsteal.find params[:jetsteal_id]
  end

end