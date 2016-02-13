organisations_app.controller "SettingsController", ['$http', 'notify', ($http, notify) ->

  @operators = []

  $http.get('/organisations/operators.json').success(
    (data)=>
      @operators = data
  ).error(
    ->
      notify(
        message: 'Error fetching operators'
        classes: ['alert-danger']
      )
  )

  return undefined
]