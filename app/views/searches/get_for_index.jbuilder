json.array! @search_activities do |search_activity|
  json.departure_airport{
    json.id search_activity.departure_airport.id
    json.label "#{search_activity.departure_airport.name}, #{search_activity.departure_airport.city.name}"
  }
  json.arrival_airport{
    json.id search_activity.arrival_airport.id
    json.label "#{search_activity.arrival_airport.name}, #{search_activity.arrival_airport.city.name}"
  }
  json.pax search_activity.pax
  json.start_at search_activity.start_at.to_s
end