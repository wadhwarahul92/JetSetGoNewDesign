class CaptchaValidator

  attr_accessor :error_codes

  URL = 'https://www.google.com/recaptcha/api/siteverify'

  def initialize(response, ip = nil)
    @response = response
    @ip = ip
  end

  def validated!(force = false)
    return true if force
    uri = URI(URL)
    response = Net::HTTP.post_form(uri, {
        secret: ENV['CAPTCHA_SECRET_KEY'],
        response: @response,
        remoteip: @ip
    })
    response = JSON.parse(response.body)
    if response['success']
      true
    else
      @error_codes = response['error-codes']
      false
    end
  end

end