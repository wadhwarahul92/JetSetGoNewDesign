  json.id @operator.id
  json.first_name @operator.first_name
  json.last_name @operator.last_name
  json.full_name @operator.full_name
  json.email @operator.email
  json.phone @operator.phone
  json.designation @operator.designation

  json.image @operator.image.url(:size_250x250) if @operator.image.present?

  json.organisation{
    json.id @operator.organisation.id
    json.name @operator.organisation.name
  }