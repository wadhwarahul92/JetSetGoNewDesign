class JetstealMailer < ApplicationMailer

  def test_mailer
    mail to: 'surajpratap@icloud.com',
         subject: 'Test to see mails are actually running'
  end

  def jesteal_seat_confirmation(jetsteal, jetsteal_seats, transaction, contact)
    @jetsteal = jetsteal
    @jetsteal_seats = jetsteal_seats
    @transaction = transaction
    @contact = contact

    attachments['Jetsteal seat confirmation.pdf'] = WickedPdf.new.pdf_from_string(
                                                                     render_to_string('pdfs/jetsteal_confirmation', layout: 'pdf')
    )

    mail to: @contact.email,
        subject: 'Jetsteal Seats Confirmed!',
        bcc: Admin.get_all_emails
  end

end