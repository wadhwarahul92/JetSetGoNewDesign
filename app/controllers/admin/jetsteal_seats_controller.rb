class Admin::JetstealSeatsController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_jetsteal, except: [:purchased_seat]

  def index
    JetstealSeatsBuilder.new(@jetsteal).build_seats unless @jetsteal.jetsteal_seats.any?
  end

  def purchased_seat
  	@payment_transactions = PaymentTransaction.where(status: 'success').where('date(updated_at) = ?', Date.today).order('created_at DESC')
  end

  private

  def set_jetsteal
    @jetsteal = Jetsteal.find params[:jetsteal_id]
  end

end