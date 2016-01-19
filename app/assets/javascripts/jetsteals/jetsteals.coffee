list_app = angular.module 'list_app', []

list_app.controller 'ListController', ['$http', ($http)->

  @colors = [
    'rgb(0, 48, 86)',
    'rgb(0, 161, 216)',
    'rgb(70, 217, 191)',
    'rgb(204, 102, 0)'
  ]

  @jetsteals = []

  @setColorsForJetsteals = ->
    for jetsteal, index in @jetsteals
      colorIndex = index % 4
      jetsteal.color = @colors[colorIndex]

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