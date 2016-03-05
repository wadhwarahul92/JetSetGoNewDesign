class TripsController < ApplicationController

  before_action :set_aircraft_and_organisation

  def enquire
    @trip = @organisation.trips.new(status: Trip::STATUS_ENQUIRY)
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
                                           handling_cost_at_takeoff: plan[:handling_cost_at_takeoff]

        )
      end

      save_able = true
      @activities.each do |activity|
        unless activity.valid?
          save_able = false
          @error = activity.errors.full_messages.first
          break
        end
      end

      if save_able
        @activities.map(&:save)
        render status: :ok, nothing: true
      else
        render status: :unprocessable_entity, json: { errors: [@error] }
      end

    else
      render status: :unprocessable_entity, json: { errors: @trip.errors.full_messages }
    end
  end

  private

  def set_aircraft_and_organisation
    @aircraft = Aircraft.find params[:enquiry][:aircraft_id]
    @organisation = @aircraft.organisation
  end

end