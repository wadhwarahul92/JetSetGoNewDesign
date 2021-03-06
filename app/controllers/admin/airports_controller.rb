class Admin::AirportsController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_airport, only: [:edit, :update]

  def index
    if params[:city_id].present?
      @airports = Airport.where(city_id: params[:city_id]).with_deleted.includes(:city).all
    elsif params[:icao_code].present?
      @airports = Airport.where('lower(icao_code) LIKE ? ', "%#{params[:icao_code].to_s.downcase}%").with_deleted.includes(:city).all
    elsif params[:name].present?
      @airports = Airport.where('lower(name) LIKE ? ', "%#{params[:name].to_s.downcase}%").with_deleted.includes(:city).all
    elsif params[:code].present?
      @airports = Airport.where('lower(code) LIKE ? ', "%#{params[:code].to_s.downcase}%").with_deleted.includes(:city).all
    else
      @airports = Airport.with_deleted.includes(:city).all
    end

  end

  def new
    @airport = Airport.new
  end

  def create
    @airport = Airport.new(airport_params)
    if @airport.save
      flash[:success] = 'Airport created successfully.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit_all
    if params[:field].present? and params[:value].present?
      @airports = Airport.where("#{params[:field]} like ?", "%#{params[:value]}%")
    else
      @airports = Airport.all
    end
  end

  def edit

  end

  def update
    if @airport.update_attributes(params.require(:airport).permit!)
      respond_to do |format|
        format.html{
          flash[:success] = 'Airport successfully updated'
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

  def destroy
    @airport = Airport.with_deleted.find params[:id]
    if @airport.deleted_at.present?
      @airport.update_attribute(:deleted_at, nil)
    else
      @airport.destroy
    end
    redirect_to action: :index
  end

  private

  def airport_params
    params.require(:airport).permit(
                                :name,
                                :city_id,
                                :longitude,
                                :latitude,
                                :code,
                                :private_landing,
                                :international,
                                :night_landing,
                                :night_parking,
                                :ifr_or_vfr,
                                :fuel_availability,
                                :watch_hour_extension,
                                :icao_code,
                                :runway_field_length_in_feet,
                                :landing_cost,
                                :bais_time_in_minutes,
                                :atc,
                                :airport_category_id,
                                :landing_minimum_mtow,
                                :landing_maximum_mtow,
                                :landing_rate_per_tonne)
  end

  def set_airport
    @airport = Airport.find params[:id]
  end

end