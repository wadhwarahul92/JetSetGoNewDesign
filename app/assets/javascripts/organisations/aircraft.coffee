organisations_app.controller 'AircraftController', ['$http', 'notify', 'AircraftsService', ($http, notify, AircraftsService)->
  
  @aircraft = {
    tail_number: 'VT-'
  }

  @aircraft_types = []

  @base_airports = []

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

  $http.get('/airports.json').success(
    (data)=>
      @base_airports = data
  ).error(
    ->
      notify(
        message: 'Error fetching airports'
        classes: ['alert-danger']
      )
  )

  @create = ->
    $http.post('/organisations/aircrafts.json', @aircraft).success(
      ->
        AircraftsService.deleteCache()
        Turbolinks.visit('/organisations/aircrafts')
    ).error(
      (data)->
        error = 'Something went wrong'
        try
          error = data.errors[0]
        notify(
          message: error
          classes: ['alert-danger']
        )
    )

  @update = ->
    $http.put("/organisations/aircrafts/#{@aircraft.id}.json", @aircraft).success(
      ->
       AircraftsService.deleteCache()
       Turbolinks.visit('/organisations/aircrafts')
    ).error(
      (data)->
        error = 'Something went wrong'
        try
          error = data.errors[0]
        notify(
          message: error
          classes: ['alert-danger']
        )
    )

  url_split = location.pathname.match(/\/organisations\/aircrafts\/(\d+)\/edit/)
  id = null
  id = url_split[1] if url_split
  if id
    $http.get("/organisations/aircrafts/#{id}/edit.json").success(
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