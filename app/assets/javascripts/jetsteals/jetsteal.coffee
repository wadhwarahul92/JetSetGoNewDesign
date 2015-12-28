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

app = angular.module 'jetsteal_app', []

app.controller 'JetstealController', [->

  @jetsteal = jetsteal

  @chosen_seats = []

  @seatClicked = (seatIndex)->
    seat = @jetsteal.jetsteal_seats[seatIndex]
    unless seat.disabled
      if @chosen_seats.indexOf(seat) >= 0
        @removeFromChosen(seat)
      else
        @addToChosen(seat)

  @addToChosen = (seat)->
    @chosen_seats.push(seat)
    console.log('Adding to chosen')

  @removeFromChosen = (seat)->
    @chosen_seats.splice(@chosen_seats.indexOf(seat), 1)
    console.log('Removing from chosen')

  @grandTotal = ->
    total = 0
    for seat in @chosen_seats
      total += seat.cost
    total

  return undefined
]

#####
$(document).on('ready page:load', ->
  if location.pathname.match(/\/jetsteals\/\d+/)
    pathArray = location.pathname.split('/')
    id = parseInt(pathArray[pathArray.length-1])
    $.ajax(
      url: "/jetsteals/#{id}/jetsteal_seats.json"
      success: (data)->
        jetsteal = new Jetsteal( $('svg').first(), data )
        jetsteal.initialize_seat_color()
        for seat, index in jetsteal.jetsteal_seats
          s = $("path##{seat.ui_seat_id}")
          s.attr('ng-click', "ctrl.seatClicked(#{index})")
        #passing to angular
        angular.bootstrap(document.body, ['jetsteal_app'])
      error: ->
        console.error 'Error fetching jetsteal data from server'
    )
)
####