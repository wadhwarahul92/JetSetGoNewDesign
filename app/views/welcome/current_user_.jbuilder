if current_user.present?
  json.id current_user.id
  json.first_name current_user.first_name
  json.last_name current_user.last_name
  json.full_name current_user.full_name
  json.designation current_user.designation if current_user.designation.present?
  json.phone current_user.phone
  json.email current_user.email
  json.dob current_user.dob
  json.sms_active current_user.sms_active
  json.image current_user.image.url(:size_250x250)
  json.api_token current_user.api_token
  if current_user.try(:organisation).present?
    json.organisation{
      json.id current_user.organisation.id
      json.name current_user.organisation.name
      json.image current_user.organisation.image.url(:size_250x250) if current_user.organisation.image.present?
    }
  end
end