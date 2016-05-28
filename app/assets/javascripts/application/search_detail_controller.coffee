jetsetgo_app.controller 'SearchDetailController', ['$http', 'notify', 'detail', 'tax', 'taxDetail', 'AirportsService', 'CurrentUserService', ($http, notify, detail, tax, taxDetail, AirportsService, CurrentUserService)->

  @detail = detail

  @airports = []

  @tax = tax

  @taxDetail = taxDetail

  AirportsService.getAirports().then(
    =>
      @airports = AirportsService.airports
  )

  @subTotal = ->
    trip = @detail
    cost = 0.0
    for flight_plan in trip.flight_plan
      cost += flight_plan.flight_cost
      cost += flight_plan.handling_cost_at_takeoff
      cost += flight_plan.landing_cost_at_arrival
      if flight_plan.watch_hour_at_arrival
        cost += flight_plan.watch_hour_cost
      if flight_plan.chosen_intermediate_plan
        chosen_plan = flight_plan[flight_plan.chosen_intermediate_plan]
        if chosen_plan and flight_plan.chosen_intermediate_plan == 'empty_leg_plan'
          for empty_leg in chosen_plan
            cost += empty_leg.flight_cost
            cost += empty_leg.handling_cost_at_takeoff
            cost += empty_leg.landing_cost_at_arrival
            if empty_leg.watch_hour_at_arrival
              cost += empty_leg.watch_hour_cost
        if chosen_plan and flight_plan.chosen_intermediate_plan == 'accommodation_plan'
          cost += chosen_plan.cost
    cost

  @totalTripCost = ->
    cost = @subTotal()
    cost + (((@tax) / 100) * cost)


  @serviceTaxCost = (percentage)->
    @subTotal() * (percentage/100)

  @airportForId = (id)->
    _.find(@airports, {id: id})

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, h:mm A')
    data

  @enquire = (detail)->
    if CurrentUserService.currentUser
      $http.post('/trips/enquire.json', {enquiry: detail}).success(
        ->
          notify
            message: 'Your enquiry has been registered. We shall contact you soon.'
          detail.enquired = true
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
      CurrentUserService.openSignInModal('md')


  @checkNotam = (detail)->
    for flight_plan in detail.flight_plan
      if flight_plan.notam_at_arrival
        @detail.is_notam = true

  @checkWatchHour = (detail)->
    for flight_plan in detail.flight_plan
      if flight_plan.watch_hour_at_arrival
        @detail.is_watch_hour = true

  return undefined
]