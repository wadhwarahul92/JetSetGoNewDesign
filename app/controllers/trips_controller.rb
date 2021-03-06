class TripsController < ApplicationController

  before_action :set_aircraft_and_organisation, only: [:enquire]

  # before_action :authenticate_user!
  before_action :authenticate_user_api

  def enquire
    @user = User.find current_user.id

    if can_enquire
      @trip = @organisation.trips.new(
          status: Trip::STATUS_ENQUIRY,
          user_id: current_user.id,
          is_miscellaneous_expenses: params[:enquiry][:is_miscellaneous_expenses],
          miscellaneous_expenses: params[:enquiry][:miscellaneous_expenses_amount]
      )
      if @trip.save

        @activities = []
        params[:enquiry][:flight_plan].each do |plan|
          @activities << @trip.activities.new(
              aircraft_id: @aircraft.id,
              departure_airport_id: plan[:departure_airport_id],
              arrival_airport_id: plan[:arrival_airport_id],
              start_at: plan[:start_at],
              end_at: plan[:end_at],
              empty_leg: (plan[:flight_type] == 'empty_leg' ? true: false),
              flight_cost: plan[:flight_cost],
              landing_cost_at_arrival: plan[:landing_cost_at_arrival],
              handling_cost_at_takeoff: plan[:handling_cost_at_takeoff],
              pax: plan[:pax],
              watch_hour_at_arrival: plan[:watch_hour_at_arrival],
              watch_hour_cost: plan[:watch_hour_cost],

          )
          if plan[:accommodation_leg].present?
            @activities.last.accommodation_plan = { nights: plan[:accommodation_leg][:nights], cost: plan[:accommodation_leg][:cost] }
          end

          # if plan[:chosen_intermediate_plan] == 'empty_leg_plan' and plan[:empty_leg_plan].present? and plan[:empty_leg_plan].length > 0
          #
          #   plan[:empty_leg_plan].each do |empty_leg|
          #
          #     @activities << @trip.activities.new(
          #         aircraft_id: @aircraft.id,
          #         departure_airport_id: empty_leg[:departure_airport_id],
          #         arrival_airport_id: empty_leg[:arrival_airport_id],
          #         start_at: empty_leg[:start_at],
          #         end_at: empty_leg[:end_at],
          #         empty_leg: true,
          #         flight_cost: empty_leg[:flight_cost],
          #         landing_cost_at_arrival: empty_leg[:landing_cost_at_arrival],
          #         handling_cost_at_takeoff: empty_leg[:handling_cost_at_takeoff],
          #         pax: 0,
          #         watch_hour_at_arrival: plan[:watch_hour_at_arrival],
          #         watch_hour_cost: plan[:watch_hour_cost]
          #     )
          #
          #   end
          #
          # elsif plan[:chosen_intermediate_plan] == 'accommodation_plan' and plan[:accommodation_plan].present?
          #
          #   # noinspection RubyResolve
          #   @activities.last.accommodation_plan = { nights: plan[:accommodation_plan][:nights], cost: plan[:accommodation_plan][:cost] }
          #
          # end

        end

        save_able = true
        @activities.each do |activity|
          unless activity.valid?
            save_able = false
            activity.trip.destroy
            @error = activity.errors.full_messages.first
            break
          end
        end

        if save_able
          @activities.map(&:save)

          is_allow = true
          enquiry_count = (@user.enquiry_count + 1)
          last_enquired = DateTime.now
          is_allow = false if enquiry_count > 9
          @user.update_attributes(enquiry_count: enquiry_count, last_enquired: last_enquired, is_allow: is_allow )


          AdminMailer.new_enquiry(current_user, @trip).deliver_later

          # OrganisationMailer.new_enquiry(current_user, @trip).deliver_later

          CustomerMailer.new_enquiry(current_user, @trip).deliver_later

          # @trip.organisation.operators.each do |operator|
          #   NotificationService.enquiry_added(operator, @trip).deliver_later
          # end

          CustomerNotificationService.enquiry_added(@trip.user, @trip).deliver_later

          SmsDelivery.new(@trip.user.phone.to_s, SmsTemplates.customer_create_enquiry('JetSetGo')).delay.deliver

          # phone_numbers = @trip.organisation.operators.map(&:phone).uniq

          # phone_numbers.each do |phone|
          #   SmsDelivery.new(phone.to_s, SmsTemplates.operator_for_enquiry('http://j.jetsetgo.in/organisations/sign_in')).delay.deliver
          # end
          render status: :ok, nothing: true
        else
          render status: :unprocessable_entity, json: { errors: [@error] }
        end

      else
        render status: :unprocessable_entity, json: { errors: @trip.errors.full_messages }
      end
    else
      render status: :unprocessable_entity, json: { errors: ["You can't enquire more then 10 times in a day."] }
    end

  end

  def get_quotes
    @quotes1 = Trip.where(
        status: Trip::STATUS_QUOTED,
        user_id: current_user.id
    ).order('updated_at DESC').includes(:activities)

    @quotes = []
    #@quotes1 = @customer.trips.where(status: Trip::STATUS_QUOTED).includes(:activities)
    if params[:quote_date].present?
      date = params[:quote_date].to_date
      @quotes1.each do |quote|
        if quote.activities.first.start_at.to_date == date
          @quotes << quote
        end
      end
      #@enquiries =  @customer.trips.where(status: Trip::STATUS_ENQUIRY).includes(:activities).where(activities: {start_at: date})
    else
      @quotes = @quotes1
    end
  end

  def show
    @trip = current_user.trips.last#.find params[:id]
  end

  private

  def set_aircraft_and_organisation
    @aircraft = Aircraft.find params[:enquiry][:aircraft_id]
    @organisation = @aircraft.organisation
  end

  def can_enquire
    flag = true

    if @user.is_allow
      # do nothing
    else
      if @user.last_enquired.strftime('%d') < DateTime.now.strftime('%d')
        is_allow = true
        enquiry_count = 0
        last_enquired = DateTime.now
        @user.update_attributes(enquiry_count: enquiry_count, last_enquired: last_enquired, is_allow: is_allow )
      else
        flag = false
      end
    end
    flag
  end

end