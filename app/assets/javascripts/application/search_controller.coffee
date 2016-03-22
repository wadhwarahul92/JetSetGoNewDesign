jetsetgo_app.controller 'SearchController', ['$http','notify','$routeParams','AirportsService', 'AircraftsService', 'CurrentUserService', ($http, notify, $routeParams, AirportsService, AircraftsService, CurrentUserService)->

  @results = []

  @airports = []

  @aircrafts = []

  @tax = null

  AirportsService.getAirports().then(
    =>
      @airports = AirportsService.airports
  )

  $http.get("/searches/#{$routeParams.id}.json").success(
    (data)=>
      @tax = data.tax
      @results = data.results
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
#    return trip.totalCost if trip.totalCost
    cost = 0.0
    for flight_plan in trip.flight_plan
      cost += flight_plan.flight_cost
      cost += flight_plan.handling_cost_at_takeoff
      cost += flight_plan.landing_cost_at_arrival
      if flight_plan.chosen_intermediate_plan
        chosen_plan = flight_plan[flight_plan.chosen_intermediate_plan]
        if chosen_plan and flight_plan.chosen_intermediate_plan == 'empty_leg_plan'
          for empty_leg in chosen_plan
            cost += empty_leg.flight_cost
            cost += empty_leg.handling_cost_at_takeoff
            cost += empty_leg.landing_cost_at_arrival
        if chosen_plan and flight_plan.chosen_intermediate_plan == 'accommodation_plan'
          cost += chosen_plan.cost
#    trip.totalCost = cost
    cost + ((@tax / 100) * cost)

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, h:mm:ss A')
    data

  @enquire = (result)->
    if CurrentUserService.currentUser
      $http.post('/trips/enquire.json', {enquiry: result}).success(
        ->
          notify
            message: 'Your enquiry has been registered. We shall contact you soon.'
      ).error(
        (data)->
          error = 'Something went wrong.'
          try
            error = data.errors[0]
          notify
            message: error
            classes: ['alert-danger']
      )
    else
      notify
        message: 'Please sign-in or register before enquiring.'
        classes: ['alert-danger']
      CurrentUserService.openSignInModal()

  @previewProForma = (result)->
    if CurrentUserService.currentUser
#      $http.post('/finances/preview_pro_forma', {result: result})
      $http({
        url: '/finances/preview_pro_forma'
        method: 'POST'
        data: {result: result}
        responseType: 'arraybuffer'
      }).success(
        (data)->
          anchor = angular.element '<a/>'
          anchor.css {display: 'none'}
          blob = new Blob([data], {type: "octet/stream"})
          url = window.URL.createObjectURL(blob)
          anchor.attr({
            href: url
            target: '_blank'
            download: 'pro forma preview.pdf'
          })[0].click();
          anchor.remove();
      ).error(
        ->
          notify
            message: 'Sorry! could not preview pro forma.'
            classes: ['alert-danger']
      )
    else
      notify
        message: 'Please sign-in or register first.'
        classes: ['alert-danger']
      CurrentUserService.openSignInModal()

  return undefined
]