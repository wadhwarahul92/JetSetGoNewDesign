class SubscriptionMailer < ApplicationMailer

  layout 'mailer_2'

  def new_jetsteals(jetsteals, subscriber)
    @jetsteals = jetsteals
    @subscriber = subscriber
    mail(
        to: subscriber.email,
        subject: 'New Jetsteals™ available'
    )
  end

end