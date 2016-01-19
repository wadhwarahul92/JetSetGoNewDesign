class Jetsteals::ListsController < Jetsteals::BaseController

  def index
    # @jetsteals = JetstealListCreator.new(params).generate_list
  end

  def show
    @jetsteal = Jetsteal.find params[:id]
  end

end