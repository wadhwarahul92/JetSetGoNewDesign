jetsetgo_app.controller 'SearchDetailController', ['$http', 'notify', 'result', 'AirportsService', 'CurrentUserService', 'CostBreakUpsService', ($http, notify, result, AirportsService, CurrentUserService, CostBreakUpsService)->

  @result = result

  @airports = []

  @calculateCost = ->
    @subTotal = CostBreakUpsService.subTotal(@result)
    @grandTotal = CostBreakUpsService.totalTripCost(@result)
    @taxBreakup = CostBreakUpsService.taxBreakUp(@result)

  AirportsService.getAirports().then(
    =>
      @airports = AirportsService.airports
      @calculateCost()
  )

  @airportForId = (id)->
    _.find(@airports, {id: id})

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, h:mm A')
    data

  @enquire = (result)->
    if CurrentUserService.currentUser
      $http.post('/trips/enquire.json', {enquiry: result}).success(
        ->
          notify
            message: 'Your enquiry has been registered. We shall contact you soon.'
          result.enquired = true
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

  @checkNotam = (result)->
    for flight_plan in result.flight_plan
      if flight_plan.notam_at_arrival
        @result.is_notam = true

  @checkWatchHour = (result)->
    for flight_plan in result.flight_plan
      if flight_plan.watch_hour_at_arrival
        @result.is_watch_hour = true

  return undefined
]