class Admin::JetstealSeatsController < Admin::BaseController

  before_filter :authenticate_admin

  before_filter :set_jetsteal, :except => [:paymented_seat]

  def index
    JetstealSeatsBuilder.new(@jetsteal).build_seats unless @jetsteal.jetsteal_seats.any?
  end

  def paymented_seat
  	@current_date = DateTime.now
  	@payment_transactions = PaymentTransaction.where( "updated_at LIKE :time AND status = :status",{:time => "#{params[:date]}%", :status => 'success'}).order('created_at DESC')

  	@payment_transactions = @payment_transactions.paginate(:per_page => 10, page: params[:page])
  end

  private

  def set_jetsteal
    @jetsteal = Jetsteal.find params[:jetsteal_id]
  end

end