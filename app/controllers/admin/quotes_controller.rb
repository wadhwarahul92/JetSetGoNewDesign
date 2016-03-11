class Admin::QuotesController < Admin::BaseController

  before_action :authenticate_admin

  before_action :set_quote, only: [:edit, :update]

  def index
   @quotes = Trip.where(status: Trip::STATUS_QUOTED).all
  end

  def edit

  end

  def update

  end

  private

  def set_quote
    @quote = Trip.where(status: Trip::STATUS_QUOTED).find params[:id]
  end

end