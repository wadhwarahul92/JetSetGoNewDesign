class Admin::ManufacturersController < Admin::BaseController

  before_filter :authenticate_admin

  before_action :set_manufacturer, only: [:edit, :update]

  def index
    @manufacturers = Manufacturer.all
  end

  def new
    @manufacturer = Manufacturer.new
  end

  def create
    @manufacturer = Manufacturer.new(manufacturer_params)
    if @manufacturer.save
      flash[:success] = 'Manufacturer created successfully.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if  @manufacturer.update_attributes(manufacturer_params)
      flash[:success] = 'Successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private

  def set_manufacturer
    @manufacturer = Manufacturer.find params[:id]
  end

  def manufacturer_params
    params.require(:manufacturer).permit(:name)
  end

end