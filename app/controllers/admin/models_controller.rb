class Admin::ModelsController < Admin::BaseController

  before_action :authenticate_admin

  before_action :set_model, only: [:show]

  def index
    @models = %w(Aircraft AircraftImage AircraftType Airport City Contact Distance Jetsteal JetstealSeat JetstealSubscription PaymentTransaction)
  end

  def show
    @model_instances = @model.paginate(page: params[:page], per_page: 20)
  end

  private

  def set_model
    @model = params[:id].constantize
  end

end