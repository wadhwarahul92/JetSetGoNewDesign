json.id current_user.id
json.first_name current_user.first_name
json.last_name current_user.last_name
json.full_name current_user.full_name

json.organisation{
  json.id current_user.organisation.id
  json.name current_user.organisation.name
  json.image current_user.organisation.image.url(:size_250x250) if current_user.organisation.image.present?
}