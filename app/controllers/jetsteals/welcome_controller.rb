class Jetsteals::WelcomeController < Jetsteals::BaseController

  def index
    redirect_to '/jetsteals/list'
  end

end