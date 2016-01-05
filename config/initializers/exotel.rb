EXOTEL_ID = ENV['EXOTEL_ID']
EXOTEL_TOKEN = ENV['EXOTEL_TOKEN']

unless EXOTEL_ID.present? or EXOTEL_TOKEN.present?
  raise 'exotel credentials are not present'
end