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

  end

end