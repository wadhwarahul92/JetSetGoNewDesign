class SmsTemplates

  class<<self

    def thanks_for_payment(service)
      "Thank you for your payment towards #{service}. For any queries please feel free to call 01139585858."
    end

    def customer_create_enquiry(service)
      "Thank you for your enquiry towards #{service}. For any queries please feel free to call 01139585858."
    end

    def generate_quote
      "Quote has been generated. Please check your account. For any queries please feel free to call 01139585858."
    end

    def customer_sign_up(service, web_link)
      "Welcome to #{service}, #{web_link} is your boarding pass to the new face of private aviation."
    end

    def operator_sign_up(service)
      "Thank you for signing up with #{service} – your ticket to a whole new world of opportunities."
    end

    def customer_for_enquiry(service)
      "#{service} will process your enquiry very shortly."
    end

    def operator_for_enquiry(link)
      "You have an enquiry – your customer is waiting. Click here for further details #{link}"
    end

    def customer_for_quote(link)
      "You have a booking confirmation awaiting your approval. View further details here #{link}"
    end

    def customer_confirm_payment(name)
      "#{name}, Thankyou for your booking payment."
    end

    def operator_get_payment(name)
      "Thankyou for servicing the query #{name} has made the booking payment."
    end

  end

end