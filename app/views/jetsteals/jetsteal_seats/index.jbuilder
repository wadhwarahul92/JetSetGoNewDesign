json.array! @jetsteal_seats do |jetsteal_seat|
  json.id jetsteal_seat.id
  json.ui_seat_id jetsteal_seat.ui_seat_id
  json.disabled jetsteal_seat.disabled?
  json.cost jetsteal_seat.cost
end