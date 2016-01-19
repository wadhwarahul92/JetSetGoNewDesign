window.chosen_seats = []

window.seatClicked = (seat)->
  if window.chosen_seats.indexOf(seat.id) >= 0
    window.chosen_seats.splice(window.chosen_seats.indexOf(seat.id), 1)
    $("path##{seat.id}").css('fill', available_seat_color)
  else
    window.chosen_seats.push(seat.id)
    $("path##{seat.id}").css('fill', chosen_seat_color)

disabled_seat_color = 'rgb(241, 92, 92)'

available_seat_color = 'rgb(242, 208, 59)'

chosen_seat_color = 'rgb(43, 201, 167)'

already_booked_color = 'rgb(51, 122, 183)'

list_app = angular.module 'list_app', []

list_app.controller 'ListController', ['$http', '$scope', '$window', ($http, $scope, $window)->

  @colors = [
    'rgb(5, 81, 139)',
    'rgb(0, 161, 216)',
    'rgb(242, 208, 59)',
    'rgb(241, 92, 92)'
  ]

  @checkFilters = ->
    setTimeout(
      ->
        if $('.count_this').length == $('.count_this.ng-hide').length
          $('#no_jetsteal').show()
        else
          $('#no_jetsteal').hide()
      ,
      100
    )
    null

  @chosen_seats = $window.chosen_seats

  @jetsteals = []

  @bookJetJetsteal = {}

  @detailsJetsteal = {}

  @bookSeatJetsteal = {}

  @filtersDontMatch = ->
    if @date and _.filter(@jetsteals, (j)-> j.date == @date ).length == 0
      return false
    if @departure_airport_id and _.filter(@jetsteals, (j) -> j.departure_airport.id == @departure_airport_id).length == 0
      return false
    if @arrival_airport_id and _.filter(@jetsteals, (j) -> j.arrival_airport.id == @arrival_airport_id).length == 0
      return false
    if @pax and _.filter(@jetsteals, (j) -> j.aircraft.seating_capacity >= @pax).length == 0
      return false
    true


  @chosen_seats_ids = ->
    ids = []
    if @bookSeatJetsteal.jetsteal_seats
      for jetsteal_seat in @bookSeatJetsteal.jetsteal_seats
        if @chosen_seats.indexOf(jetsteal_seat.ui_seat_id) >= 0
          ids.push(jetsteal_seat.id)
    ids

  @resetChosenSeats = ->
    @chosen_seats = $window.chosen_seats

  @priceFor = (seat_id)->
    for jetsteal_seat in @bookSeatJetsteal.jetsteal_seats
      if jetsteal_seat.ui_seat_id == seat_id
        return jetsteal_seat.cost

  @grandTotal = ->
    total = 0
    if @bookSeatJetsteal.jetsteal_seats
      for jetsteal_seat in @bookSeatJetsteal.jetsteal_seats
        if @chosen_seats.indexOf(jetsteal_seat.ui_seat_id) >= 0
          total += jetsteal_seat.cost
    total

  @seatClicked = ->
    alert 'seat clicked'

  @paintSeatWithInitialColor = ->
    for seat, index in @bookSeatJetsteal.jetsteal_seats
      if seat.disabled
        $("path##{seat.ui_seat_id}").css('fill', disabled_seat_color)
      else if seat.booked
        $("path##{seat.ui_seat_id}").css('fill', already_booked_color)
      else
        s = $("path##{seat.ui_seat_id}")
        s.css('fill', available_seat_color)
        s.attr('onclick', "seatClicked(#{s.attr('id')})")
    null

  @bookSeatClicked = (jetsteal)->
    @bookSeatJetsteal = jetsteal
    window.chosen_seats = []
    @resetChosenSeats()
    $http.get("/aircraft_types/#{jetsteal.aircraft.aircraft_type.id}.json").success(
      (data)=>
        @bookSeatJetsteal.aircraft.aircraft_type.svg = data.svg
        $('#svg_holder').html(data.svg)
        $('#book_seat_modal').foundation('open')
        @paintSeatWithInitialColor()
    ).error(
      ->
        alert 'error fetching aircraft type'
    )
    null

  @detailsClicked = (jetsteal)->
    @detailsJetsteal = jetsteal
    $('.reveal-overlay').css('background-color', jetsteal.color)
    null

  @setColorsForJetsteals = ->
    for jetsteal, index in @jetsteals
      colorIndex = index % 4
      jetsteal.color = @colors[colorIndex]

  @bookJetClicked = (jetsteal)->
    @bookJetJetsteal = jetsteal
    $('.reveal-overlay').css('background-color', jetsteal.color)
    null

  # fetching jetsteals
  $http.get('/jetsteals/get_list.json').success(
    (data)=>
      @jetsteals = data
      @setColorsForJetsteals()
  ).error(
    ->
      alert 'error fetching jetsteals, try again later'
  )
  ####################

  undefined
]

$(document).on('ready page:load', ->
  angular.bootstrap(document.body, ['list_app'])
)