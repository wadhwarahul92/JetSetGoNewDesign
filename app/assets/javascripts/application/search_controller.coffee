jetsetgo_app.controller 'SearchController', ['$http','notify','$routeParams','AirportsService', 'AircraftsService', 'CurrentUserService', '$uibModal', 'CostBreakUpsService', '$location', '$scope', ($http, notify, $routeParams, AirportsService, AircraftsService, CurrentUserService, $uibModal, CostBreakUpsService, $location, $scope)->

  @results = []

  @airports = []

  @aircrafts = []

  @user = false

  @searchId = $routeParams.id

  @loading = true

  @active_xs_search_bar = false

  @disable_ = true

  @search_activities = []

  @search_activities_static = []

  @c_filter = []

  @subTotal = 0.0
  @grandTotal = 0.0
  @taxBreakup = []

  @filterSeatingCapacity = []
  @filterSeatingCapacity = ['0','35']

  $scope.$watch(
    =>
      @search_activities
  ,
    =>
      @formatActivities()
  ,
    true
  )

  @onSetTime = (newDate, oldDate, index)->
    if index + 1 == @search_activities.length
#do nothing
    else
      alert 'cannot change date'
      @search_activities[index].start_at  = oldDate

  if CurrentUserService.currentUser != null
    @user = CurrentUserService.currentUser

  AirportsService.getAirports().then(
    =>
      @airports = AirportsService.airports
  )

  $http.get("/aircraft_categories.json").success(
    (data)=>
      @aircraft_categories = data
  ).error(
    (data)->
      error = 'Something went wrong.'
      try
        error = data.errors[0]
      notify
        message: error
        classes: ['alert-danger']
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
      for search_activity in @search_activities
        search_activity.departure_airport = @airportForId(search_activity.departure_airport_id)
        search_activity.arrival_airport = @airportForId(search_activity.arrival_airport_id)
        search_activity.start_at = new Date(search_activity.start_at)


      @search_activities_static = JSON.parse(JSON.stringify @search_activities)

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


  @addActivity = ->
    return unless @validatedActivities()
    @search_activities.push {}

  @addRoundTrip = ->
    return unless @validatedActivities()
    @search_activities.push {arrival_airport: @search_activities[0].departure_airport}

  @removeActivity = (index)->
    if index > 0
      @search_activities.splice index, 1

  @validatedActivities = ->
    for activity in @search_activities
      unless activity.departure_airport
        notify
          message: 'Departure cannot be blank.'
          classes: ['alert-danger']
        return false
      unless activity.arrival_airport
        notify
          message: 'Arrival cannot be blank'
          classes: ['alert-danger']
        return false
      if activity.departure_airport == activity.arrival_airport
        notify
          message: 'Departure cannot be same as Arrival.'
          classes: ['alert-danger']
        return false
      unless activity.start_at
        notify
          message: 'Time cannot be blank.'
          classes: ['alert-danger']
        return false
      unless activity.pax
        notify
          message: 'Pax cannot be blank.'
          classes: ['alert-danger']
        return false
    true

  @create = ->
    return unless @validatedActivities()
    _activities = []
    for activity in @search_activities
      _activities.push({
        departure_airport_id: activity.departure_airport.id
        arrival_airport_id: activity.arrival_airport.id
        start_at: activity.start_at
        pax: activity.pax
      })
    $http.post('/searches.json', { activities: _activities }).success(
      (data)->
        $location.path("/searches/#{data.search_id}")
    ).error(
      (data)->
        error = 'Something went wrong.'
        try
          error = data.errors[0]
        notify
          message: error
          classes: ['alert-danger']
    )

  @formatActivities = ->
    previous = null
    for search_activity in @search_activities
      if previous
        search_activity.departure_airport = previous.arrival_airport
      previous = search_activity

  @beforeRenderDate = (view, dates, leftDate, upDate, rightDate, index)->
    activeDate = null
    if index > 0
      previous_activity = @search_activities[index-1]
      time = previous_activity.start_at
      previous_date = time.getDate()
      previous_month = time.getMonth()
      if view == 'day'
        for __date in dates
          if parseInt(__date.display) < previous_date and (new Date(__date.localDateValue())).getMonth() == previous_month
            __date.selectable = false
      else
        if time
          activeDate = moment(time)
          for date in dates
            if date.localDateValue() <= activeDate.valueOf()
              date.selectable = false
    else
      activeDate = moment(new Date())
      for _date in dates
        if _date.localDateValue() <= activeDate.valueOf()
          _date.selectable = false

  @calculateCost = (result)->
    @subTotal = CostBreakUpsService.subTotal(result)
    @grandTotal = CostBreakUpsService.totalTripCost(result)
    @taxBreakup = CostBreakUpsService.taxBreakUp(result)

  @lessThan = (prop, val)->
    item = []
    item.push

  return undefined
]