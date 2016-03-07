json.id @trip.id
json.status @trip.status
json.activities{
  json.array! @trip.activities do |activity|
    json.id activity.id
    json.aircraft_id activity.aircraft_id
    json.departure_airport_id activity.departure_airport_id
    json.arrival_airport_id activity.arrival_airport_id
    json.start_at activity.start_at.strftime(time_format)
    json.end_at activity.end_at.strftime(time_format)
    json.empty_leg activity.empty_leg?
    json.pax (activity.pax.presence || 0)
    json.flight_cost activity.flight_cost
    json.handling_cost_at_takeoff activity.handling_cost_at_takeoff
    json.landing_cost_at_arrival activity.landing_cost_at_arrival
    if activity.accommodation_plan.present?
      json.accommodation_plan{
        json.cost activity.accommodation_plan[:cost]
        json.nights activity.accommodation_plan[:nights]
      }
    end
  end
}