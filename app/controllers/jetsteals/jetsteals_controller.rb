class Jetsteals::JetstealsController < Jetsteals::BaseController

  before_action :set_jetsteal

  def buy_as_whole

  end

  private

  def set_jetsteal
    @jetsteal = Jetsteal.find params[:id]
    @whole_jet = params[:buy_as_whole] if params[:buy_as_whole].present?
  end

end