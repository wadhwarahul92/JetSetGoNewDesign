class Jetsteals::JetstealsController < Jetsteals::BaseController

  before_action :set_jetsteal

  def buy_as_whole

  end

  private

  def set_jetsteal
    @jetsteal = Jetsteal.find params[:id]
  end

end