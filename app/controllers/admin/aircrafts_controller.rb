class Admin::AircraftsController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_aircraft, only: [:show, :edit, :update, :admin_approve]

  def index
    @aircrafts = Aircraft.includes(:aircraft_type).all
  end

  def new
    @aircraft = Aircraft.new
  end

  def show

  end

  def edit

  end

  def edit_all
    if params[:field].present? and params[:value].present?
      @aircrafts = Aircraft.where("#{params[:field]} like ?", "%#{params[:value]}%")
    else
      @aircrafts = Aircraft.all
    end
  end

  def update
    if @aircraft.update_attributes(params.require(:aircraft).permit!)
      respond_to do |format|
        format.html{
          flash[:success] = 'Aircraft successfully updated'
          redirect_to action: :index
        }
        format.json{
          render status: :ok, nothing: true
        }
      end
    else
      respond_to do |format|
        format.html{
          render action: :edit
        }
        format.json{
          render status: :unprocessable_entity, nothing: true
        }
      end
    end
  end

  def admin_approve
    if @aircraft.update_attribute(:admin_verified, params[:admin_verified])
      if params[:admin_verified] == 'true'
        AdminMailer.aircraft_approved_by_admin(current_user, @aircraft).deliver_later
        OrganisationMailer.aircraft_approved_by_super_admin(@aircraft).deliver_later
      else
        AdminMailer.aircraft_disapproved_by_admin(current_user, @aircraft).deliver_later
        OrganisationMailer.aircraft_disapproved_by_super_admin(@aircraft).deliver_later
      end
      redirect_to action: :index
    else
      redirect_to action: :index
    end
  end

  def create
    @aircraft = Aircraft.new(aircraft_params)
    if @aircraft.save
      flash[:success] = 'Aircraft successfully created.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  private

  def aircraft_params
    params.require(:aircraft).permit(
                                 :tail_number,
                                 :aircraft_type_id,
                                 :seating_capacity,
                                 :baggage_capacity_in_kg,
                                 :landing_field_length_in_feet,
                                 :runway_field_length_in_feet,
                                 :number_of_toilets,
                                 :cabin_width_in_meters,
                                 :cabin_height_in_meters,
                                 :cabin_length_in_meters,
                                 :memorable_name,
                                 :crew,
                                 :wifi,
                                 :phone,
                                 :flight_attendant,
                                 :cruise_speed_in_nm_per_hour,
                                 :flying_range_in_nm,
                                 :per_hour_cost,
                                 # :catering_cost_per_pax,
                                 :organisation_id,
                                 :year_of_manufacture,
                                 :medical_evac,
                                 :base_airport_id,
                                 :mtow,
                                 :image
    )
  end

  def set_aircraft
    @aircraft = Aircraft.find params[:id]
  end

end