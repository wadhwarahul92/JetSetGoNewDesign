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

  @update = ->
    $http.put("/operators/aircrafts/#{@aircraft.id}.json", @aircraft).success(
      ->
        location.replace('/operators/aircrafts')
    ).error(
      (data)->
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )
  
  if ("#{location.pathname.split('/')[1]}" == 'operators') && ("#{location.pathname.split('/')[2]}" == 'aircrafts') && ("#{location.pathname.split('/')[4]}" == 'edit')
    $http.get("/operators/aircrafts/#{location.pathname.split('/')[3]}/edit.json").success(
      (data)=>
        @aircraft = data
    ).error(
      ->
        notify(
          message: 'Error fetching aircraft types'
          classes: ['alert-danger']
        )
    )

  return undefined
]