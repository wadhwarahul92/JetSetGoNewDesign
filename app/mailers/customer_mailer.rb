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
        subject: 'Welcome to JetSetGo'
    )
  end

end