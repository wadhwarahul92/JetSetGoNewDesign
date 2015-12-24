class Admin::AircraftImagesController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_aircraft

  before_filter :set_aircraft_image, only: [:destroy]

  def new

  end

  def create
    @aircraft_image = @aircraft.aircraft_images.new(aircraft_image_params)
    if @aircraft_image.save
      flash[:success] = 'Image added successfully'
      redirect_to admin_aircraft_path(@aircraft)
    else
      render template: 'admin/aircrafts/show'
    end
  end

  def destroy
    @aircraft_image.destroy!
    redirect_to admin_aircraft_path(@aircraft)
  end

  private

  def set_aircraft_image
    @aircraft_image = @aircraft.aircraft_images.find params[:id]
  end

  def set_aircraft
    @aircraft = Aircraft.find params[:aircraft_id]
  end

  def aircraft_image_params
    params.require(:aircraft_image).permit(
        :image
    )
  end

end