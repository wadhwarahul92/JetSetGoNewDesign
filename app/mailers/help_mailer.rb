class HelpMailer < ApplicationMailer

  layout 'help_mailer'

  def support_ticket(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(
        to: 'info@jetsetgo.in',
        subject: 'Someone raised a support topic',
        bcc: Admin.get_all_emails
    )
  end

end