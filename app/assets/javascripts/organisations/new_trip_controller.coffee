organisations_app.controller 'NewTripController', ['$http', 'notify', 'AircraftsService', '$scope', ($http, notify, AircraftsService, $scope)->

  @airports = []

  @aircraft = null

  @aircraft_id = null

  @paxRange = _.range(30)

  @activities = [
    {
      departure_airport_id: null
      arrival_airport_id: null
      start_at: null
      empty_leg: false
      pax: 0
    }
  ]

  $scope.$watch(
    =>
      @aircraft_id
    ,
    =>
      if @aircraft_id
        @getAircraft()
  )

  @getAircraft = ->
    $http.get("/organisations/aircrafts/#{@aircraft_id}.json").success(
      (data)=>
        @aircraft = data
    ).error(
      ->
        notify
          message: 'Error fetching aircraft, 1x10098'
          classes: ['alert-danger']
    )

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, h:mm:ss A')
    if data and data == 'Invalid date'
      return 'Click to choose time'
    else
      return data

  @addActivity = ->
    @activities.push {
      departure_airport_id: null
      arrival_airport_id: null
      start_at: null
      empty_leg: false
      pax: 0
    }

  @deleteActivity = (activity)->
    @activities.splice @activities.indexOf(activity), 1

  @create = ->
    if @aircraft
      $http.post('/organisations/trips.json', {aircraft_id: @aircraft_id, activities: @activities}).success(
        ->
          notify
            message: 'New trip created'
          Turbolinks.visit '/organisations'
      ).error(
        (data)->
          error = 'Something went wrong'
          try
            error = data.errors[0]
          notify
            message: error
            classes: ['alert-danger']
      )
    else
      notify
        message: 'Choose aircraft first'
        classes: ['alert-danger']

  AircraftsService.getAircraftsForCurrentOperator().then(
    =>
      @aircrafts = AircraftsService.aircraftsForCurrentOperator
  )

  $http.get('/airports.json').success(
    (data)=>
      for airport in data
        @airports.push {
          id: airport.id
          label: "#{airport.name}, #{airport.city.name}"
        }
  ).error(
    ->
      notify(
        message: 'Error fetching airports'
        classes: ['alert-danger']
      )
  )

  return undefined
]