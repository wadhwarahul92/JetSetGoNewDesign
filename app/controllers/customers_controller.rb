class CustomersController < ApplicationController

  before_action :set_customer, only: [:update_image, :update_profile]

  def update_image
    if @customer.update_attributes(image: params[:file])
      render status: :ok, json: { image_url: @customer.image.url(:size_250x250) }
    else
      render status: :unprocessable_entity, json: { errors: @customer.errors.full_messages }
    end
  end

  def update_profile
    if @customer.update_attributes(phone: params[:phone])
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @customer.errors.full_messages }
    end
  end

  def booked_jets
    @trips = Trip.where(user_id: @customer.id, status: Trip::STATUS_CONFIRMED)
    render layout: false
  end

  def upcoming_journeys
    @trips = []
    @trips = Trip.where(user_id: @customer.id, status: Trip::STATUS_CONFIRMED)
    if @trips.any?
      @trips = get_upcoming_trips(@trips)
    end
    render layout: false
  end

  def past_journeys
    @trips = get_past_trips(Trip.where(user_id: @customer.id, status: Trip::STATUS_CONFIRMED))
    render layout: false
  end

  def enquired_jets
    @enquiries = Trip.where(user_id: @customer.id, status: Trip::STATUS_ENQUIRY)
    render layout: false
  end

  def empty_legs_offered

  end

  private

  def set_customer
    @customer = current_user
  end

  def get_past_trips(trips)
    ids = []
    trips.each do |trip|
      trip.activities.where("end_at < ?", DateTime.now).map{ |t| ids << t.trip_id }
    end
    trips.where(id: ids.uniq)
  end

  def get_upcoming_trips(trips)
    ids = []
    trips.each do |trip|
      trip.activities.where("start_at > ?", DateTime.now).map{ |t| ids << t.trip_id }
    end
    trips.where(id: ids.uniq)
  end

end