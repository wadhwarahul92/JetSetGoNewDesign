jetsetgo_app.controller 'SearchController', ['$http','notify','$routeParams','AirportsService', 'AircraftsService', 'CurrentUserService', '$uibModal', 'CustomerCostBreakUpsService', '$location', '$scope', 'AircraftCategoriesService', ($http, notify, $routeParams, AirportsService, AircraftsService, CurrentUserService, $uibModal, CustomerCostBreakUpsService, $location, $scope, AircraftCategoriesService)->

  @active_min_height = true
  @loading = true

  @jsg_commision = CustomerCostBreakUpsService.commission

  @results_ = []
  @results = []

  @airports = []

  @aircrafts = []

  @aircraft_categories = []

  @user = false

  @search_bar_active = false

  @searchId = $routeParams.id

  @active_xs_search_bar = false

  @disable_ = true

  @search_activities = []

  @airport_break_ups= []

  @search_activities_static = []

  @c_filter = []

  @min_cost = ''

  @max_cost = ''

  @filter_cost = ''

  @subTotal = 0.0
  @grandTotal = 0.0
  @taxBreakup = []

  @enquireBeforeLogin = {}

  @current_user_present = false

  @search_notam_active = false

  @totalItems = 0
  @currentPage = 1
  @perPage = 10
  @isLoadMoreActive = false

  $scope.$watch(
    =>
      @search_activities
  ,
    =>
      @formatActivities()
  ,
    true
  )

  $scope.$watch(
    =>
      if CurrentUserService.currentUser
        @current_user_present = true
  )

#  setTimeout(
#    ->
#      for result in @results
#        result.totalCost = @totalTripCost(result)
#        result.taxBreakup = CustomerCostBreakUpsService.taxBreakUp(result)
#        result.subTotal = CustomerCostBreakUpsService.subTotal(result)
#        result.night_flight = @check_night_landing(result)
##        result.totalFlyingTime = @calculateFlyingTime(result)
#  ,
#    1500
#  )

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

  AircraftCategoriesService.getAircraftCategories().then(
    =>
      @aircraft_categories = AircraftCategoriesService.aircraft_categories
  )

#  $http.get("/aircraft_categories.json").success(
#    (data)=>
#      @aircraft_categories = data
#  ).error(
#    (data)->
#      error = 'Something went wrong.'
#      try
#        error = data.errors[0]
#      notify
#        message: error
#        classes: ['alert-danger']
#  )

  $http.get("/searches/#{$routeParams.id}.json").success(
    (data)=>
      @results_ = _.sortBy(data.results, 'aircraft_per_hour_cost')
      @results = @set_results(@results_, @perPage)

      if @results.length > @perPage-1
        @isLoadMoreActive = true

#      @check_night_landing(@results)

      @airport_break_ups = data.airport_break_ups
#      @search_notam_active = @check_search_notam_active(@airport_break_ups)
      if @check_search_notam_active(@airport_break_ups)
        @search_bar_active = true
        @search_notam_active = true
      else
        @search_bar_active = false

      @search_activities = data.search_activities

      if @results[0]
        @loading = true
        AircraftsService.getAircraftsForIds(_.pluck(@results, 'aircraft_id')).then(
          =>
            @aircrafts = AircraftsService.aircrafts
            for result in @results
              result.aircraft = _.find(@aircrafts, {id: result.aircraft_id})
              result.aircraft.aircraft_category = @aircraftCategoryForId(result.aircraft.aircraft_type.aircraft_category_id)
              @set_costs(result)
            @loading = false
            @active_min_height = false
            @load_more()
        )
      else
        @loading = false
        @active_min_height = false

      for search_activity in @search_activities
        search_activity.departure_airport = @airportForId(search_activity.departure_airport_id)
        search_activity.arrival_airport = @airportForId(search_activity.arrival_airport_id)
        search_activity.start_at = new Date(search_activity.start_at)

      @count_night_flight = 0

      @search_activities_static = JSON.parse(JSON.stringify @search_activities)
      if @results.length > 0
        @min_cost = parseInt(_.first(@results).totalCost - 1).toString()
        @max_cost = parseInt(_.last(@results).totalCost + 1).toString()
        @filter_cost = "'"+@min_cost+','+ @max_cost+"'"
      else
        @min_cost = 0
        @max_cost = 0
        @filter_cost = "'"+0+','+ 0+"'"
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

  @aircraftCategoryForId = (id)->
    _.find(@aircraft_categories, {id: id})

  @totalTripCost = (trip)->
    CustomerCostBreakUpsService.totalTripCost(trip)

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, h:mm:ss A')
    if data and data == 'Invalid date'
      return 'Departure time'
    else
      return data

  @formatTime2 = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, h:mm A')
    if data and data == 'Invalid date'
      return 'Departure time'
    else
      return data

  @formatTime3 = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY')
    if data and data == 'Invalid date'
      return 'Departure time'
    else
      return data

  @formatTime4 = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('h:mm A')
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
      @enquireBeforeLogin = result
      CurrentUserService.openSignInModal('md')


  @previewProForma = (result)->
#    if CurrentUserService.currentUser
##      $http.post('/finances/preview_pro_forma', {result: result})
#      $http({
#        url: '/finances/preview_pro_forma'
#        method: 'POST'
#        data: {result: result}
#        responseType: 'arraybuffer'
#      }).success(
#        (data)->
#          anchor = angular.element '<a/>'
#          anchor.css {display: 'none'}
#          blob = new Blob([data], {type: "octet/stream"})
#          url = window.URL.createObjectURL(blob)
#          anchor.attr({
#            href: url
#            target: '_blank'
#            download: 'pro forma preview.pdf'
#          })[0].click();
#          anchor.remove();
#      ).error(
#        ->
#          notify
#            message: 'Sorry! could not preview pro forma.'
#            classes: ['alert-danger']
#      )
#    else
#      notify
#        message: 'Please sign-in or register first.'
#        classes: ['alert-danger']
#      CurrentUserService.openSignInModal('md')


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
          download: 'JSG pro forma preview.pdf'
        })[0].click();
        anchor.remove();
    ).error(
      ->
        notify
          message: 'Sorry! could not preview pro forma.'
          classes: ['alert-danger']
    )

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

  @checkNotam = (result, index)->
    result.is_notam = false
    for flight_plan in result.flight_plan
       if flight_plan.notam_at_arrival
         result.is_notam = true
         @results = _.without(@results, _.findWhere(@results, {aircraft_id: result.aircraft_id}))

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

  @customSplit = (string)->
    string.split(',')

  @include_commission = (cost)->
    cost + @jsg_commision/100 * cost

#  @aircraft_flight_cost_commission_in_percentage = (cost, percentage)->
#    cost + percentage/100 * cost
#
#  @aircraft_handling_cost_commission_in_percentage = (cost, percentage)->
#    cost + percentage/100 * cost
#
#  @aircraft_accomodation_cost_commission_in_percentage = (cost, percentage)->
#    cost + percentage/100 * cost

#  @aircraft_flight_cost_commission_in_percentage = (cost, percentage)->
#    cost + percentage/100 * cost
#
#  @aircraft_handling_cost_commission_in_percentage = (cost, percentage)->
#    cost + percentage/100 * cost
#
#  @aircraft_accomodation_cost_commission_in_percentage = (cost, percentage)->
#    cost + percentage/100 * cost

  @check_empty_leg = (trip)->
    flag = false
    for plan in trip.flight_plan
      if plan.flight_type == 'empty_leg'
         flag = true
    flag

  @enquireOnLogin = (result)->
    @enquire(result)
    @enquireBeforeLogin = {}

#  @check_night_landing = (result)->
#    night = false
#    for flight_plan in result.flight_plan
#
#      end_at = moment(flight_plan.start_at).add(flight_plan.flight_time.split(':')[0],'hours')
#      end_at = moment(end_at).add(flight_plan.flight_time.split(':')[1],'minutes')
#
#      if @is_night_time(moment(flight_plan.start_at).format("HH")) or @is_night_time(moment(end_at).format("HH"))
#        night = true
#    night

  @check_night_landing = (result)->
    can_night_land = true
    for flight_plan in result.flight_plan
      end_at = moment(flight_plan.start_at).add(flight_plan.flight_time.split(':')[0],'hours')
      end_at = moment(end_at).add(flight_plan.flight_time.split(':')[1],'minutes')
      if @is_night_time(moment(flight_plan.start_at).format("HH"))
        if @airportForId(flight_plan.departure_airport_id).night_landing
          # do nothing
        else
          can_night_land = false
      if @is_night_time(moment(end_at).format("HH"))
        if @airportForId(flight_plan.arrival_airport_id).night_landing
         # do nothing
        else
          can_night_land = false
    can_night_land

  @is_night_time = (time_hour)->
    night = false
#    if 6 < parseInt(time_hour) and parseInt(time_hour) < 18
    if 5 > parseInt(time_hour) or parseInt(time_hour) > 17
      night = true
    night

  @has_all_night_landing_airport = (is_night_flight)->
    if is_night_flight
      @count_night_flight = @count_night_flight + 1
    @loading = false
    if @count_night_flight == 0 or @results.length < 9
      @isLoadMoreActive = false

  @set_costs = (result)->
    result.totalCost = @totalTripCost(result)
    result.taxBreakup = CustomerCostBreakUpsService.taxBreakUp(result)
    result.subTotal = CustomerCostBreakUpsService.subTotal(result)
    result.night_flight = @check_night_landing(result)

  @total_customer_flight_plan_time = (result)->
    hours = 0
    minutes = 0
    seconds = 0
    flight_time_ = ''
    for plan in result.flight_plan
#      unless plan.flight_type == 'empty_leg'
      hours += parseInt(plan.flight_time.split(':')[0])
      minutes += parseInt(plan.flight_time.split(':')[1])
      seconds += parseInt(plan.flight_time.split(':')[2])

    if seconds > 59
      minutes += parseInt(seconds/60)
      seconds = seconds % 60

    if minutes > 59
      hours += parseInt(minutes/60)
      minutes = minutes % 60

#    minutes +=  parseInt(seconds/60)
#    hours +=  parseInt(minutes/60)

    flight_time_ = (hours.toString()+' Hrs ' +minutes.toString()+ ' Mins')

  @cost_with_commission_in_percentage = (result, aircraft)->
    result.total_flight_cost = 0.0
    result.total_handling_cost = 0.0
    result.set_watch_hour = false
    result.total_flight_time = ''
    result.set_accomodation = false
    result.total_accommodation_cost = 0.0
    result.total_accommodation_nights = 0

    for plan in result.flight_plan
      result.total_flight_cost += plan.flight_cost
      result.total_handling_cost += plan.handling_cost_at_takeoff + plan.landing_cost_at_arrival
      if plan.accommodation_leg
        result.set_accomodation = true
        result.total_accommodation_cost += (plan.accommodation_leg.cost)
        result.total_accommodation_nights += plan.accommodation_leg.nights
      if plan.watch_hour_at_arrival
        result.set_watch_hour  = true
    result.total_flight_cost = (result.total_flight_cost + (result.total_flight_cost * (result.aircraft.flight_cost_commission_in_percentage/100)))
    result.total_handling_cost = (result.total_handling_cost + (result.total_handling_cost * (result.aircraft.handling_cost_commission_in_percentage/100)))
    result.total_accommodation_cost = (result.total_accommodation_cost + (result.total_accommodation_cost * (result.aircraft.accomodation_cost_commission_in_percentage/100)))

  @check_search_notam_active = ->
    flag = false
#    for break_up in @airport_break_ups
#      if break_up.is_notam
#        flag = true
    flag

  @doMediaQuery = (result)->
    result.more_detail_active = true
    w = angular.element(window).width()
    if w < 768
      result.more_detail_active = false

  @set_results = (data, n)->
    _.first(data, [n])

#  @apply_filter = ->
#    @aircraft_categories


  @load_more = ->
    @isLoadMoreActive = false
    @currentPage = @currentPage + 1

    prevAircraftIds = _.pluck(@results, 'aircraft_id')

    data = @set_results(@results_, @perPage*@currentPage)
    restAircraftIds = _.difference(_.pluck(data, 'aircraft_id'), prevAircraftIds)

    if restAircraftIds.length > @perPage-1
#      do nothing
    else
      @isLoadMoreActive = false

    if restAircraftIds.length > 0
      @results = _.union(@results, data)

      AircraftsService.getAircraftsForIds(restAircraftIds).then(
        =>
          aircrafts = AircraftsService.aircrafts
          for result in data
            result.aircraft = _.find(aircrafts, {id: result.aircraft_id})
            result.aircraft.aircraft_category = @aircraftCategoryForId(result.aircraft.aircraft_type.aircraft_category_id)
            @set_costs(result)
          @isLoadMoreActive = true
          @load_more()

      )

  return undefined
]