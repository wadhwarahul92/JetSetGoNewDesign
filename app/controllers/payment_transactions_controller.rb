class PaymentTransactionsController < ApplicationController

  #post request from payment processor dont contain csrf tokens
  protect_from_forgery except: [:success, :cancel, :failure]

  before_filter

  def create
    @jetsteal_seat_purchaser = JetstealSeatPurchaser.new(
                                                        params[:jetsteal_id],
                                                        params[:jetsteal_seat_ids],
                                                        params[:first_name],
                                                        params[:last_name],
                                                        params[:phone],
                                                        params[:email]
    )
  end

  def success
    if params[:productinfo] == 'JetstealSeats'
      if validated_params!
        transaction = find_payment_transaction
        transaction.update_attributes!(
                       status: 'success',
                       processor_response: params.to_s
        )
        jetsteal_seats = find_jetsteal_seats
        jetsteal_seats.each{ |s| s.update_attribute(:payment_transaction_id, transaction.id) }
      else
        render action: :failure
      end
    end
  end

  def cancel

  end

  def failure

  end

  private

  def validated_params!
    params[:hash] == Digest::SHA2.new(512).hexdigest("#{PAYU_SALT}|#{params[:status]}|||||||||#{params[:udf2]}|#{params[:udf1]}|#{params[:email]}|#{params[:firstname]}|#{params[:productinfo]}|#{params[:amount]}|#{params[:txnid]}|#{params[:key]}")
  end

  def find_payment_transaction
    if Rails.env == 'production'
      PaymentTransaction.find params[:txnid]
    else
      PaymentTransaction.find(params[:txnid].to_i + 99999999)
    end
  end

  def find_jetsteal_seats
    JetstealSeat.where(id: JSON.parse(params[:udf1]))
  end

end