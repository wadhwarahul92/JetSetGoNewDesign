class Admin::ConfirmedTripsController < Admin::BaseController

  before_action :authenticate_admin

  before_action :set_trip, only: [:show]

  def index
    @confirmed_trips = Trip.where(status: Trip::STATUS_CONFIRMED).order(id: :desc).all.paginate(page: params[:page], per_page: 50)
  end

  def show

  end

  private

  def set_trip
    @confirmed_trip = Trip.where(status: Trip::STATUS_CONFIRMED).find params[:id]
  end

end