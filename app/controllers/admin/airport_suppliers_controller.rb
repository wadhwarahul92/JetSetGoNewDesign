class Admin::AirportSuppliersController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_airport_supplier, only: [:edit, :update]

  def index
    @airport_suppliers = AirportSupplier.all
  end

  def new
    @airport_supplier = AirportSupplier.new
  end

  def create
    @airport_supplier = AirportSupplier.new(airport_supplier_params)
    if @airport_supplier.save
      flash[:success] = 'Airport supplier created successfully.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @airport_supplier.update_attributes(airport_supplier_params)
      flash[:success] = 'Airport supplier successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private

  def airport_supplier_params
    params.require(:airport_supplier).permit(:halt_type,
                                             :minimum_mtow,
                                             :maximum_mtow,
                                             :minimum_amount,
                                             :offset_amount,
                                             :rate_per_tonne,
                                             :royalty,
                                             :additional_rate,
                                             :other_service_cost,
                                             :max_other_service)
  end

  def set_airport_supplier
    @airport_supplier = AirportSupplier.find params[:id]
  end

end