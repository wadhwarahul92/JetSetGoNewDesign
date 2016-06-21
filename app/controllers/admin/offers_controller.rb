class Admin::OffersController < Admin::BaseController

  before_filter :authenticate_admin

  before_action :set_offer, only: [:edit, :update]

  def index
    @offers = Offer.all
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(params_offer)
    if @offer.save
      flash[:success] = 'Offer successfully created.'
      redirect_to action: :index
    else
      render action: :new
    end
  end

  def edit

  end

  def update
    if @offer.update_attributes(params_offer)
      flash[:success] = 'Successfully updated'
      redirect_to action: :index
    else
      render action: :edit
    end
  end

  private

  def params_offer
    params.require(:offer).permit(:start_at,
                                  :end_at,
                                  :category,
                                  :image)
  end

  def set_offer
    @offer = Offer.find params[:id]
  end


end