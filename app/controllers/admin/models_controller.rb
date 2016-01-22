class Admin::ModelsController < Admin::BaseController

  before_action :authenticate_admin

  def index
    @models = %w(Aircraft AircraftImage AircraftType Airport City Contact Distance Jetsteal JetstealSeat JetstealSubscription PaymentTransaction)
  end

end