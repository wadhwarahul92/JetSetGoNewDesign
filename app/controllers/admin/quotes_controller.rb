class Admin::QuotesController < Admin::BaseController

  before_action :authenticate_admin

  before_action :set_quote, only: [:show]

  def index
   @quotes = Trip.where(status: Trip::STATUS_QUOTED).all
  end

  def show

  end

  private

  def set_quote
    @quote = Trip.where(status: Trip::STATUS_QUOTED).find params[:id]
  end

end