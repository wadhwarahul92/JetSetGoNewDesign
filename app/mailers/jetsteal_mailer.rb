class JetstealMailer < ApplicationMailer

  def test_mailer
    mail to: 'suraj.pratap@jetsetgo.in',
         subject: 'Test to see mails are actually running'
  end

  def jesteal_seat_confirmation(jetsteal, jetsteal_seats, transaction, contact)
    @jetsteal = jetsteal
    @jetsteal_seats = jetsteal_seats
    @transaction = transaction
    @contact = contact

    mail to: @contact.email,
        subject: 'Jetsteal Seats Confirmed!',
        bcc: Admin.get_all_emails
  end

end