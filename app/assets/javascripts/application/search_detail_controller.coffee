#jetsetgo_app.controller 'SearchDetailController', ['$http', 'notify', 'detail', 'tax', 'taxDetail', 'AirportsService', 'CurrentUserService', 'CostBreakUpsService', '$scope', ($http, notify, detail, tax, taxDetail, AirportsService, CurrentUserService, CostBreakUpsService, $scope)->
jetsetgo_app.controller 'SearchDetailController', ['$http', 'notify', 'detail', 'AirportsService', 'CurrentUserService', 'CostBreakUpsService', '$scope', ($http, notify, detail, AirportsService, CurrentUserService, CostBreakUpsService, $scope)->

  @detail = detail

  @airports = []

  AirportsService.getAirports().then(
    =>
      @airports = AirportsService.airports
  )

  @totalTripCost = (trip)->
    CostBreakUpsService.totalTripCost(trip)

  @serviceTaxCost = (trip)->
    $scope.tax_array = CostBreakUpsService.taxBreakUp(trip)

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