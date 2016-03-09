json.array! @cities do |city|
  json.id city.id
  json.name city.name
  json.state city.state
  if city.image.present?
    json.image city.image.url(:original)
  end
end