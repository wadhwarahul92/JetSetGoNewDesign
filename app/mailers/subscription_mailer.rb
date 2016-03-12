class SubscriptionMailer < ApplicationMailer

  layout 'mailer_2'

  def new_jetsteals(jetsteals, subscriber)
    @jetsteals = jetsteals
    @subscriber = subscriber
    mail = mail(
        to: subscriber.email,
        subject: 'New JetSteals™ available'
    )
    if subscriber.send_emails?
      mail
    else
      mail.singleton_class.class_eval do
        def deliver
          #do nothing
        end
      end
      mail
    end
  end

  def new_multi_jetsteals(jetsteals, subscriber)
    @jetsteals = jetsteals
    @subscriber = subscriber
    mail = mail(
        to: subscriber.email,
        subject: 'JetSetGo: New JetSteals™ available'
    )
    if subscriber.send_emails?
      mail
    else
      mail.singleton_class.class_eval do
        def deliver
          #do nothing
        end
      end
      mail
    end
  end

  def new_jetsteal(jetsteal, subscriber)
    @jetsteal = jetsteal
    @subscriber = subscriber
    mail = mail(
        to: subscriber.email,
        subject: 'JetSetGo: New JetSteal available'
    )
    if subscriber.send_emails?
      mail
    else
      mail.singleton_class.class_eval do
        def deliver
          #do nothing
        end
      end
      mail
    end
  end
end