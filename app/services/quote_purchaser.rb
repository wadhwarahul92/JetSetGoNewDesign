class QuotePurchaser

  attr_accessor :status

  def initialize(params)
    @params = params
  end

  def process_purchase
    find_user
    find_contact
    find_quote
    create_payment_transaction
    mark_payment
  end

  private

  def find_contact
    @contact = Contact.where(email: @user.email).first_or_create(
                                                    email: @user.email,
                                                    first_name: @user.first_name,
                                                    last_name: @user.last_name,
                                                    phone: @user.phone
    )
  end

  def find_user
    @user = User.find @params['merchant_param2']
  end

  def find_quote
    @quote = Trip.find @params['merchant_param3']
  end

  def create_payment_transaction
    @payment_transaction = @contact.payment_transactions.create!(status: 'pending')
  end
  
  def mark_payment
    if @params['order_status'] == 'Success'
      @payment_transaction.update_attributes!(
          status: 'success',
          processor_response: @params.to_s,
          amount: @params['amount'],
          billing_address: @params['billing_address'],
          billing_city: @params['billing_city'],
          billing_state: @params['billing_state'],
          billing_zip: @params['billing_zip'],
          billing_country: @params['billing_country'],
      )
      @quote.update_attributes(
                status: Trip::STATUS_CONFIRMED,
                payment_transaction_id: @payment_transaction.id
      )
      @status = 'success'
    else
      @payment_transaction.update_attributes!(
          status: 'failure',
          processor_response: @params.to_s,
          amount: @params['amount'],
          billing_address: @params['billing_address'],
          billing_city: @params['billing_city'],
          billing_state: @params['billing_state'],
          billing_zip: @params['billing_zip'],
          billing_country: @params['billing_country'],
      )
      @status = 'failure'
    end
  end

end