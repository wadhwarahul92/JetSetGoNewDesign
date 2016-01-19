class Jetsteals::ListsController < Jetsteals::BaseController

  def index
    # @jetsteals = JetstealListCreator.new(params).generate_list
  end

  def show
    @jetsteal = Jetsteal.find params[:id]
  end

  def get_list
    @jetsteals = JetstealListCreator.new(params).generate_list(false)
  end

end