class CustomerMailer < ApplicationMailer

  add_template_helper(ApplicationHelper)

  layout 'mailer_2'

  ######################################################################
  # Description: When a customer create an enquiry
  # @param [Customer] customer
  # @return [ActionMailer::Base]
  ######################################################################
  def new_enquiry(customer, trip)
    @trip = trip
    @customer = customer
    mail(
        to: @customer.email,
        subject: 'JetSetGo - Your Private Jet Enquiry has been Received.'
    )
  end

  ######################################################################
  # Description: When a customer sign up
  # @param [Customer] customer
  # @return [ActionMailer::Base]
  ######################################################################
  def sign_up(customer)
    @customer = customer
    mail(
        to: @customer.email,
        subject: 'Confirmation instructions'
    )
  end

  ######################################################################
  # Description: When an operator send a quote to customer
  # @param [Customer] customer
  # @param [Trip] trip
  # @return [ActionMailer::Base]
  ######################################################################
  def send_quote(customer, trip)
    @trip = trip
    @customer = customer
    mail(
        to: @customer.email,
        subject: 'JetSetGo - Quotation For Your Private Jet.'
    )
  end

  ######################################################################
  # Description: When customer share email to add passenger details
  # @param [email] email
  # @param [Trip] trip
  # @return [ActionMailer::Base]
  ######################################################################
  def share_email(email, trip_id, token)
    @trip_id = trip_id
    @email = email
    @token = token
    mail(
        to: @email,
        subject: 'JetSetGo - Share passenger detail'
    )
  end

  def payment_success(trip)
    @trip = trip
    @customer = @trip.user
    @email = @customer.email
    mail(
        to: @email,
        subject: "JetSetGo - Our booking has been confirmed for Flight #{@trip.activities.first.aircraft.tail_number}"
    )
  end

  def create_yatra_enquiry(yatra_enquiry)
    @yatra_enquiry = yatra_enquiry
    mail(
        to: @yatra_enquiry.email,
        subject: "JetSetGo - Thank for your enquiry."
    )
  end

  def forgot_password(operator, token)

    @operator = operator
    @token = token
    mail(
        to: @operator.email,
        subject: 'JetSetGo - password reset'
    )
  end



end