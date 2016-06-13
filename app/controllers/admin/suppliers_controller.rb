class Admin::SuppliersController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_supplier, only: [:edit, :update]

  def index
    @suppliers = Supplier.all
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      flash[:success] = 'Supplier successfully created.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @supplier.update_attributes(supplier_params)
      flash[:success] = 'Successfully updated.'
      redirect_to action: :index
    else
      render action: :new
    end

  end

  private

  def supplier_params
    params.require(:supplier).permit(:name,
                                     :fuel_supplier,
                                     :ground_handling,
                                     :other_services)

  end

  def set_supplier
    @supplier = Supplier.find params[:id]
  end

end