class AdminMailer < ApplicationMailer

  layout 'admin_mailer'

  def operator_signed_up(operator)
    @operator = operator
    mail(
        to: Admin.get_all_emails,
        subject: 'Operator Sign Up Notification'
    )
  end

  def new_jetsteal(jetsteal, subscribers)
    @jetsteal = jetsteal
    @subscribers = subscribers
    mail(
        to: Admin.get_all_emails,
        subject: 'New jetsteal added'
    )
  end

end