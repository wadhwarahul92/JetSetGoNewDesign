class Admin::TaxesController < Admin::BaseController

  before_action :authenticate_admin

  def index
    @tax = Tax.first || Tax.new
  end

  def create
    @tax = Tax.first || Tax.new
    @tax.service_tax = params[:tax][:service_tax]
    @tax.swachh_bharat_cess = params[:tax][:swachh_bharat_cess]
    if @tax.save
      flash[:success] = 'Taxes updated.'
      redirect_to action: :index
    else
      render action: :index
    end
  end

end