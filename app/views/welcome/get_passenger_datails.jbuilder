json.array! @passenger_details do |passenger_detail|

  json.id passenger_detail.id
  json.title passenger_detail.title
  json.name passenger_detail.name
  json.gender passenger_detail.gender
  json.contact passenger_detail.contact
  json.age passenger_detail.age
  json.email passenger_detail.email

end