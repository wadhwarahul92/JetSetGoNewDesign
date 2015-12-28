class Jetsteal

  disabled_seat_color = 'red'

  available_seat_color = 'rgb(232, 159, 43)'

  selected_seat_color = 'green'

  constructor: (@jetsteal_aircraft, @jetsteal_seats)->

  initialize_seat_color: ->
    for jetsteal_seat in @jetsteal_seats
      if jetsteal_seat.disabled
        @jetsteal_aircraft.find("path##{jetsteal_seat.ui_seat_id}").css('fill', disabled_seat_color)
      else
        @jetsteal_aircraft.find("path##{jetsteal_seat.ui_seat_id}").css('fill', available_seat_color)


jetsteal = null

pathArray = location.pathname.split('/')
id = parseInt(pathArray[pathArray.length-1])
$.ajax(
  url: "/jetsteals/#{id}/jetsteal_seats.json"
  success: (data)->
    jetsteal = new Jetsteal( $('svg').first(), data )
    jetsteal.initialize_seat_color()
  error: ->
    console.error 'Error fetching jetsteal data from server'
)