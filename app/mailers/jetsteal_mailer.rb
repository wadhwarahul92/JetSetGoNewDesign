class JetstealMailer < ApplicationMailer

  def test_mailer
    mail to: 'surajpratap@icloud.com',
         subject: 'Test to see mails are actually running'
  end

  def jetsteal_seat_confirmation(jetsteal, jetsteal_seats, transaction, contact)
    @jetsteal = jetsteal
    @jetsteal_seats = jetsteal_seats
    @transaction = transaction
    @contact = contact

    token = ENV['FINANCE_TOKEN']
    password = ENV['FINANCE_PASSWORD']

    ###creating invoice on invoice system
    url = nil
    if Rails.env.development?
      url = 'http://localhost:3001/api/v1'
    else
      url = 'http://jet-set-go-finance.herokuapp.com/api/v1'
    end
    begin
      address = "#{@transaction.billing_address}\n#{@transaction.billing_city}, #{@transaction.billing_state}, #{@transaction.billing_country}\n#{@transaction.billing_zip}"
    rescue
      address = ' -- '
    end
    #creating pro_forma_invoice
    response = Net::HTTP.post_form(URI("#{url}/create_pro_forma"), {
        client_name: @contact.full_name,
        aircraft: @jetsteal.aircraft.aircraft_type.name,
        departure_airport: @jetsteal.departure_airport.name,
        arrival_airport: @jetsteal.arrival_airport.name,
        amount: @transaction.amount,
        token: token,
        client_address: address,
        pass: password
    })
    if response.code == '200'
      pro_forma_id = JSON.parse(response.body)['id']
      response = Net::HTTP.post_form(URI("#{url}/create_invoice"), {
          pro_forma_invoice_id: pro_forma_id,
          token: token,
          pass: password
      })
      if response.code == '200'
        invoice_id = JSON.parse(response.body)['id']
        response = Net::HTTP.get(URI("#{url}/invoice/#{invoice_id}?token=#{token}&pass=#{password}&format=pdf"))
        if response[0..3] == '%PDF'
          attachments['invoice.pdf'] = response
        end
      end
    end
    ###########################

    attachments['Jetsteal seat confirmation.pdf'] = WickedPdf.new.pdf_from_string(
        render_to_string('pdfs/jetsteal_confirmation', layout: 'pdf')
    )

    mail to: @contact.email,
         subject: 'Jetsteal Seats Confirmed!',
         bcc: Admin.get_all_emails
  end

end