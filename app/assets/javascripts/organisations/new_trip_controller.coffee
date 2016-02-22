organisations_app.controller 'NewTripController', ['$http', 'notify', 'AircraftsService', ($http, notify, AircraftsService)->

  trips = []

  @airports = []

  @aircraft_id = null

  @activities = [
    {
      departure_airport_id: null
      arrival_airport_id: null
      start_at: null
      empty_leg: false
      pax: 0
    }
  ]

  @paxRange = _.range(30)

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