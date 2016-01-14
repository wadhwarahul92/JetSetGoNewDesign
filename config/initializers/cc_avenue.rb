CC_MERCHANT_ID = ENV['CC_MERCHANT_ID']
CC_ACCESS_KEY = ENV['CC_ACCESS_KEY']
CC_WORKING_KEY = ENV['CC_WORKING_KEY']
if Rails.env.production?
  CC_URL = 'https://secure.ccavenue.com'
else
  CC_URL = 'https://test.ccavenue.com'
end
#raise error if cc avenue is not present
unless CC_MERCHANT_ID.present? or CC_ACCESS_KEY.present? or CC_WORKING_KEY.present?
  raise 'cc avenue credentials are empty'
end