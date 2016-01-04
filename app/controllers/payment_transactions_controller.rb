# noinspection RailsChecklist01
class PaymentTransactionsController < ApplicationController

  #post request from payment processor dont contain csrf tokens
  protect_from_forgery except: [:success, :cancel, :failure]

  layout 'jetsteals'

  def create
    @jetsteal_seat_purchaser = JetstealSeatPurchaser.new(
                                                        params[:jetsteal_id],
                                                        params[:jetsteal_seat_ids],
                                                        params[:first_name],
                                                        params[:last_name],
                                                        params[:phone],
                                                        params[:email]
    )
    seat_locker = JetstealSeatLocker.new(@jetsteal_seat_purchaser.jetsteal_seats)
    if @jetsteal_seat_purchaser.validated_seats! and seat_locker.all_allowed_for_sale? and seat_locker.lock_all_for_sale
      #proceed
    else
      flash[:error] = 'Oops! looks like the seat you tried to booked has been booked by someone else. Please reload and try again.'
      redirect_to "/jetsteals/#{@jetsteal_seat_purchaser.jetsteal.id}"
    end
  end

  def success
    #this is very sensitive
    #todo by Suraj, please make this fool proof, investigate possible loopholes
    if params[:productinfo] == 'JetstealSeats'
      #must be validated
      if validated_params!
        transaction = find_payment_transaction
        @jetsteal = find_jetsteal
        @jetsteal_seats = find_jetsteal_seats
        @jetsteal_seats.map(&:validate_if_double_sale)
        transaction.update_attributes!(
            status: 'success',
            processor_response: params.to_s
        )
        #adding transaction id to jetsteal seat books it
        @jetsteal_seats.each{ |s| s.update_attribute(:payment_transaction_id, transaction.id) }
        JetstealMailer.jesteal_seat_confirmation(@jetsteal, @jetsteal_seats.to_a, transaction, Contact.find(transaction.contact_id)).deliver_later
      else
        render action: :failure
      end
    end
  end

  def cancel
    render action: :failure
  end

  def failure
    #possibly unlock all seats here.
  end

  private

  def validated_params!
    params[:hash] == Digest::SHA2.new(512).hexdigest("#{PAYU_SALT}|#{params[:status]}|||||||||#{params[:udf2]}|#{params[:udf1]}|#{params[:email]}|#{params[:firstname]}|#{params[:productinfo]}|#{params[:amount]}|#{params[:txnid]}|#{params[:key]}")
  end

  def find_payment_transaction
    if Rails.env == 'production'
      #todo change this
      PaymentTransaction.find(params[:txnid].to_i + 99999999)
    else
      PaymentTransaction.find(params[:txnid].to_i + 99999999)
    end
  end

  def find_jetsteal_seats
    JetstealSeat.where(id: JSON.parse(params[:udf1]))
  end

  def find_jetsteal
    Jetsteal.find params[:udf2]
  end

end