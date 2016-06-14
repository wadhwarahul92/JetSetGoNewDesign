class Admin::AircraftTypesController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_aircraft_type, only: [:edit, :update]

  def index
    @aircraft_types = AircraftType.all
  end

  def new
    @aircraft_type = AircraftType.new
  end

  def create
    @aircraft_type = AircraftType.new(aircraft_type_params)
    if @aircraft_type.save
      flash[:success] = 'Aircraft type successfully created'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit_all
    if params[:field].present? and params[:value].present?
      @aircraft_types = AircraftType.where("#{params[:field]} like ?", "%#{params[:value]}%")
    else
      @aircraft_types = AircraftType.all
    end
  end

  def edit

  end

  def update
    if @aircraft_type.update_attributes(params.require(:aircraft_type).permit!)
      respond_to do |format|
        format.html{
          flash[:success] = 'Aircraft type successfully updated'
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

  private

  def aircraft_type_params
    params.require(:aircraft_type).permit(
                                      :name,
                                      :svg,
                                      :speed_in_kts,
                                      :description
    )
  end

  def set_aircraft_type
    @aircraft_type = AircraftType.find params[:id]
  end

end