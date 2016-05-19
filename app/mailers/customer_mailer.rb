class CustomerMailer < ApplicationMailer

  add_template_helper(ApplicationHelper)

  layout 'mailer_2'

  def new_enquiry(customer, trip)
    @trip = trip
    @customer = customer
    mail(
        to: @customer.email,
        subject: 'JetSetGo - Enquiry'
    )
  end

end