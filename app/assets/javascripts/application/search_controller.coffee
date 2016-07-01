jetsetgo_app.controller 'SearchController', ['$http','notify','$routeParams','AirportsService', 'AircraftsService', 'CurrentUserService', '$uibModal', 'CostBreakUpsService', ($http, notify, $routeParams, AirportsService, AircraftsService, CurrentUserService, $uibModal, CostBreakUpsService)->

  @results = []

  @result_activities = []

  @airports = []

  @aircrafts = []

  @user = false

  @searchId = $routeParams.id

  @loading = true

  @active_xs_search_bar = false

  if CurrentUserService.currentUser != null
    @user = CurrentUserService.currentUser

  AirportsService.getAirports().then(
    =>
      @airports = AirportsService.airports
  )

  $http.get("/searches/#{$routeParams.id}.json").success(
    (data)=>
      @results = data.results
      @search_activities = data.search_activities

      for result in @results
        result.totalCost = @totalTripCost(result)

      AircraftsService.getAircraftsForIds(_.pluck(@results, 'aircraft_id')).then(
        =>
          @aircrafts = AircraftsService.aircrafts
          for result in @results
            result.aircraft = _.find(@aircrafts, {id: result.aircraft_id})
          @loading = false
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
    CostBreakUpsService.totalTripCost(trip)

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, h:mm:ss A')
    if data and data == 'Invalid date'
      return 'Departure time'
    else
      return data

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
      CurrentUserService.openSignInModal('md')

  @modalDetail = (result)->
    $uibModal.open(
      size: 'lg'
      templateUrl: '/templates/search_detail'
      controller: 'SearchDetailController'
      controllerAs: 'ctrl'
      backdrop: true
      resolve: {
        result: ->
          return result
      }
    )

  @checkNotam = (result)->
    for flight_plan in result.flight_plan
       if flight_plan.notam_at_arrival
         result.is_notam = true

  return undefined
]