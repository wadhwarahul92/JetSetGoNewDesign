class SmsDelivery

  EXOTEL_URL = "https://#{EXOTEL_ID}:#{EXOTEL_TOKEN}@twilix.exotel.in/v1/Accounts/#{EXOTEL_ID}/Sms/send"

  SENDER_NUMBER = '09243422233'

  def initialize(number, text)
    @number = number
    @text = text
  end

  def deliver
    Net::HTTP.post_form(URI(EXOTEL_URL),
                        'From' => SENDER_NUMBER,
                        'To' => @number,
                        'Body' => @text
    )
  end

end