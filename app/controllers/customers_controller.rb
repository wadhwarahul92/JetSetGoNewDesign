class CustomersController < ApplicationController

  before_action :set_customer, only: [:update_image,
                                      :update_profile,
                                      :get_booked_jets,
                                      :get_upcoming_journeys,
                                      :get_past_journeys,
                                      :get_enquired_jets,
                                      # :empty_legs_offered,
                                      :get_quoted_journeys,
                                      :get_offers,
                                      :catering,
                                      :set_sell_empty_leg,
                                      :get_user_trips,
                                      :get_confirmed_jetsteals,
                                      :change_password_,
                                      :get_dates,
                                      :activity_sell_empty_leg]

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

    @trips = @customer.trips.where(status: Trip::STATUS_CONFIRMED).includes(:activities).order(id: :desc)

  end

  def get_upcoming_journeys
    @trips = @customer.trips.where(status: Trip::STATUS_CONFIRMED).includes(:activities)
    if @trips.present?
      @trips = get_upcoming_trips(@trips)
    end
  end

  def get_past_journeys
    @trips = get_past_trips(@customer.trips.where(status: Trip::STATUS_CONFIRMED)).includes(:activities)
  end

  def get_dates
    @dates = []
    @enquiries1 = @customer.trips.where(status: Trip::STATUS_ENQUIRY).includes(:activities).order(id: :desc)
    @enquiries1.each do |enquiry|
      enquiry.activities.each do |activity|
        @dates << activity.start_at.to_date
      end
    end
    @dates = @dates.uniq!
  end

  def get_enquired_jets
    @enquiries = []
    @enquiries1 = @customer.trips.where(status: Trip::STATUS_ENQUIRY).includes(:activities).order(id: :desc)
    if params[:enq_date].present?
      date = params[:enq_date].to_date
      @enquiries1.each do |enquiry|
        if enquiry.activities.first.start_at.to_date == date
          @enquiries << enquiry
        end
      end
      #@enquiries =  @customer.trips.where(status: Trip::STATUS_ENQUIRY).includes(:activities).where(activities: {start_at: date})
    else
      @enquiries = @enquiries1
    end
  end

  def get_quoted_journeys
    @quotes = @customer.trips.where(status: Trip::STATUS_QUOTED).includes(:activities)
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
                                                                        :nationality,
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

  def get_confirmed_jetsteals
    @jetsteals1 = get_jet_steals
    @jetsteals = []
    if params[:con_date].present?
      date = params[:con_date].to_date
      @jetsteals1[:trips].each do |trip|
        if trip.activities.first.start_at.to_date == date
          @jetsteals << trip
        end
      end
    else
      @jetsteals = @jetsteals1
    end
  end

  def activity_sell_empty_leg
    @trip = @customer.trips.find params[:trip_id]
    if @trip.present?
      @activity = @trip.activities.find params[:activity_id]
      if @activity.present?
        if @activity.update_attributes(in_sale: params[:in_sale], minimum_sale_price: params[:minimum_sale_price], maximum_sale_price: params[:maximum_sale_price], sell_button_clicked: true)
          render status: :ok, nothing: true
        else
          render status: :unprocessable_entity, json: { errors: @activity.errors.full_messages }
        end
      else
        render status: :unprocessable_entity, json: { errors: 'Activity not present' }
      end
    else
      render status: :unprocessable_entity, json: { errors: 'Trip not present' }
    end

    # if @trip.update_attributes(sell_empty_leg: params[:sell_empty_leg])
    #   render status: :ok, nothing: true
    # else
    #   render status: :unprocessable_entity, json: { errors: @trip.errors.full_messages }
    # end
  end

  def share_email
    if current_user.present? and params[:email].present? and params[:trip_id].present?
      token = nil
      if current_user.present?
        token = current_user.api_token
        CustomerMailer.share_email(params[:email], params[:trip_id], token).deliver_later
        render status: :ok, nothing: true
      else
        render status: :unprocessable_entity, nothing: true
      end
    else
      render status: :unprocessable_entity, nothing: true
    end
  end

  def get_shared_trip
    if params[:token].present? and params[:trip_id].present?
      token = params[:token]
      trip_id = params[:trip_id]
      user = User.where(api_token: token).first
      if user.present?
        @trip = user.trips.where(id: trip_id).first
        # render status: :ok, nothing: true
      else
        render status: :unprocessable_entity, nothing: true
      end

    else
      render status: :unprocessable_entity, nothing: true
    end
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

  def get_jet_steals
    jetsteals = nil
    confirmed_jetsteals = nil
    contact = Contact.where(email: current_user.email).first
    if contact.present?
      jetsteal_ids = contact.payment_transactions.where(status: 'success', is_jetsteal: true).map(&:jetsteal_id)
      jetsteals = Jetsteal.where(id: jetsteal_ids)
    end
    # jetsteals

    confirmed_jetsteals = {
        trips: @customer.trips.where(status: Trip::STATUS_CONFIRMED).order(id: :desc),
        jetsteals: jetsteals
    }
  end

  # def set_required_params
  #   params.require(:required_variables).permit(
  #       :token,
  #       :trip_id
  #   )
  # end

end