class CustomersController < ApplicationController

  before_action :set_customer, only: [:update_image,
                                      :update_profile,
                                      :get_booked_jets,
                                      :get_upcoming_journeys,
                                      :get_past_journeys,
                                      :get_enquired_jets,
                                      :empty_legs_offered,
                                      :get_quoted_journeys,
                                      :get_offers,
                                      :catering,
                                      :set_sell_empty_leg,
                                      :get_user_trips,
                                      :change_password_]

  def update_image
    if @customer.update_attributes(image: params[:file])
      render status: :ok, json: { image_url: @customer.image.url(:size_250x250) }
    else
      render status: :unprocessable_entity, json: { errors: @customer.errors.full_messages }
    end
  end

  def update_profile
    if @customer.update_attributes(phone: params[:phone], dob: params[:dob], sms_active: params[:sms_active])
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @customer.errors.full_messages }
    end
  end

  def get_booked_jets
    @trips = @customer.trips.where(status: Trip::STATUS_CONFIRMED).order(id: :desc)
  end

  def get_upcoming_journeys
    @trips = @customer.trips.where(status: Trip::STATUS_CONFIRMED)
    if @trips.present?
      @trips = get_upcoming_trips(@trips)
    end
  end

  def get_past_journeys
    @trips = get_past_trips(@customer.trips.where(status: Trip::STATUS_CONFIRMED))
  end

  def get_enquired_jets
    @enquiries = @customer.trips.where(status: Trip::STATUS_ENQUIRY).order(id: :desc)
  end

  def get_quoted_journeys
    @quotes = @customer.trips.where(status: Trip::STATUS_QUOTED)
  end

  def get_offers
    @offers = Offer.where("end_at > ?", DateTime.now).last(4)
  end

  def create_passengers
    @passenger_details = []
    params[:passenger_details].each do |passenger_detail|
      @passenger_details << PassengerDetail.new(passenger_detail.permit(:title,
                                                                        :name,
                                                                        :email,
                                                                        :age,
                                                                        :contact,:trip_id,
                                                                        :gender))
    end

    @error = nil
    @passenger_details.each do |passenger_detail|
      unless passenger_detail.valid?
        @error = passenger_detail.errors.full_messages.first
      end
    end

    # noinspection RubyResolve
    if @error.present?
      render status: :unprocessable_entity, json: { errors: [@error] }
    else
      @passenger_details.map(&:save)
      render status: :ok, nothing: true
    end
  end

  def catering
    @trip = @customer.trips.find params[:trip_id]
    if @trip.update_attributes(catering: params[:catering])
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @trip.errors.full_messages }
    end
  end

  def set_sell_empty_leg
    @trip = @customer.trips.find params[:trip_id]
    if @trip.update_attributes(sell_empty_leg: params[:sell_empty_leg])
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @trip.errors.full_messages }
    end
  end

  def change_password_
    if @customer.update_attributes(password: params[:password])
      render status: :ok, nothing: true
    else
      render status: :unprocessable_entity, json: { errors: @customer.errors.full_messages }
    end
  end

  def get_user_trips
    @trips = @customer.trips
  end

  private

  def set_customer
    if current_user.present?
      @customer = current_user
    else
      redirect_to root_path
    end

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