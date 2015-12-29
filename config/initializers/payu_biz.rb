if Rails.env == 'production'
  PAYU_SALT = ENV['PAYU_SALT']
  PAYU_ID = ENV['PAYU_ID']
else
  PAYU_SALT = 'eCwWELxi'
  PAYU_ID = 'gtKFFx'
end