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