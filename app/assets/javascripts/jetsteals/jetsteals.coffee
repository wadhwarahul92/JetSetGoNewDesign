list_app = angular.module 'list_app', []

list_app.controller 'ListController', ['$http', ($http)->

  @colors = [
    'rgb(5, 81, 139)',
    'rgb(0, 161, 216)',
    'rgb(242, 208, 59)',
    'rgb(241, 92, 92)'
  ]

  @jetsteals = []

  @bookJetJetsteal = {}

  @detailsJetsteal = {}

  @bookSeatJetsteal = {}

  @bookSeatClicked = (jetsteal)->
    @bookSeatJetsteal = jetsteal
    $http.get("/aircraft_types/#{jetsteal.aircraft.aircraft_type.id}.json").success(
      (data)=>
        @bookSeatJetsteal.aircraft.aircraft_type.svg = data.svg
        $('#svg_holder').html(data.svg)
        $('#book_seat_modal').foundation('open')
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