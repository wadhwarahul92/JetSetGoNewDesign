jetsetgo_app.controller 'SearchController', ['$http','notify','$routeParams','AirportsService', 'AircraftsService', ($http, notify, $routeParams, AirportsService, AircraftsService)->

  @results = []

  @airports = []

  @aircrafts = []

  AirportsService.getAirports().then(
    =>
      @airports = AirportsService.airports
  )

  $http.get("/searches/#{$routeParams.id}.json").success(
    (data)=>
      @results = data
      for result in @results
        @totalTripCost(result)
      AircraftsService.getAircraftsForIds(_.pluck(@results, 'aircraft_id')).then(
        =>
          @aircrafts = AircraftsService.aircrafts
          for result in @results
            result.aircraft = _.find(@aircrafts, {id: result.aircraft_id})
      )
  ).error(
    (data)->
      error = 'Something went wrong.'
      try
        error = data.errors[0]
      notify
        message: error
        classes: ['alert-danger']
  )

  @airportForId = (id)->
    _.find(@airports, {id: id})

  @totalTripCost = (trip)->
    return trip.totalCost if trip.totalCost
    cost = 0.0
    for flight_plan in trip.flight_plan
      cost += flight_plan.flight_cost
      cost += flight_plan.handling_cost_at_takeoff
      cost += flight_plan.landing_cost_at_arrival
    trip.totalCost = cost
    cost

  return undefined
]