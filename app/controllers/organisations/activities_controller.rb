class Organisations::ActivitiesController < Organisations::BaseController

  before_action :authenticate_operator

  def show
    if request.format == 'application/json'
      @activity = Activity.find params[:id]
    end
  end

end