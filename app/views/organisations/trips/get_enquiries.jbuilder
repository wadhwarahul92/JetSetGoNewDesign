json.array! @enquiries do |enquiry|

  json.id enquiry.id

  json.status enquiry.status

  json.user_id enquiry.user_id

  json.activities{
    json.array! enquiry.activities do |activity|
      # ksjdcks
    end
  }

end