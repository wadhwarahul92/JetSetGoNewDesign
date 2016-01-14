class Jetsteals::JetstealsController < Jetsteals::BaseController

  before_action :set_jetsteal

  def buy_as_whole
    respond_to do |format|
      format.html{ redirect_to "/jetsteals/list?btn_click=#{params[:buy_as_whole]}" }
      format.js
    end
  end

  private

  def set_jetsteal
    @jetsteal = Jetsteal.find params[:id]
  end

end