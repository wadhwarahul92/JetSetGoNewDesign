operator_app.controller 'AircraftController', ['$http', 'notify', ($http, notify)->
  
  @aircraft = {
    tail_number: 'VT-'
  }

  @aircraft_types = []

  $http.get('/aircraft_types.json').success(
    (data)=>
      @aircraft_types = data
  ).error(
    ->
      notify(
        message: 'Error fetching aircraft types'
        classes: ['alert-danger']
      )
  )

  @create = ->
    $http.post('/operators/aircrafts.json', @aircraft).success(
      ->
        location.replace('/operators/aircrafts')
    ).error(
      (data)->
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )

  return undefined
]