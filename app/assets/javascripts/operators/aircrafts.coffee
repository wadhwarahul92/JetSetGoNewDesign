operator_app.controller 'AircraftsController', ['$http', 'notify', ($http, notify)->

  @aircrafts = []

  $http.get('/operators/aircrafts.json').success(
    (data)=>
      @aircrafts = data
  ).error(
    ->
      notify(
        message: 'Error fetching aircrafts'
        classes: ['alert-danger']
      )
  )

  return undefined
]