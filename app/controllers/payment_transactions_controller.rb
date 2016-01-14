# noinspection RailsChecklist01
class PaymentTransactionsController < ApplicationController

  #post request from payment processor dont contain csrf tokens
  protect_from_forgery except: [:success, :cancel, :failure]

  before_action :decrypt_params, only: [:success]

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
      if seat_locker.all_allowed_for_sale?
        flash[:error] = 'Oops! looks like the seat you tried to booked has been booked by someone else. Please reload and try again.'
      else
        flash[:error] = 'Oops! looks like someone else is trying to book one of the seat you chose. Please choose other seats or wait for some time.'
      end
      redirect_to "/jetsteals/#{@jetsteal_seat_purchaser.jetsteal.id}"
    end
  end

  def success
    if @response_data['order_status'] == 'Success'
      transaction = find_payment_transaction
      @jetsteal = find_jetsteal
      @jetsteal_seats = find_jetsteal_seats
      @jetsteal_seats.map(&:validate_if_double_sale)
      @contact = Contact.find(transaction.contact_id)
      transaction.update_attributes!(
          status: 'success',
          processor_response: params.to_s
      )
      #adding transaction id to jetsteal seat books it
      @jetsteal_seats.each{ |s| s.update_attribute(:payment_transaction_id, transaction.id) }
      JetstealMailer.jesteal_seat_confirmation(@jetsteal, @jetsteal_seats.to_a, transaction, @contact).deliver_later
      SmsDelivery.new(@contact.phone.to_s, SmsTemplates.thanks_for_payment('Jetsteal')).delay.deliver
    else
      render action: :failure
    end
  end

  def cancel
    render action: :failure
  end

  def failure
    #possibly unlock all seats here.
  end

  private

  # def validated_params!
  #   params[:hash] == Digest::SHA2.new(512).hexdigest("#{PAYU_SALT}|#{params[:status]}|||||||||#{params[:udf2]}|#{params[:udf1]}|#{params[:email]}|#{params[:firstname]}|#{params[:productinfo]}|#{params[:amount]}|#{params[:txnid]}|#{params[:key]}")
  # end

  def find_payment_transaction
    PaymentTransaction.find @response_data['order_id']
  end

  def find_jetsteal_seats
    JetstealSeat.where(id: JSON.parse(@response_data['merchant_param2']))
  end

  def find_jetsteal
    Jetsteal.find @response_data['merchant_param1']
  end

  def decrypt_params
    decrypted_string = CcCrypto.new.decrypt(params[:encResp], CC_WORKING_KEY)
    @response_data = {}
    decrypted_string.split('&').each do |data|
      @response_data[data.split('=')[0]] = data.split('=')[1]
    end
  end

end