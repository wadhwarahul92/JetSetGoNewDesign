jetsetgo_app.controller 'IndexController', ['$http', 'notify', 'AirportsService', '$scope', '$location', '$routeParams', 'CurrentUserService', '$uibModal', 'AircraftCategoriesService', ($http, notify, AirportsService, $scope, $location, $routeParams, CurrentUserService, $uibModal, AircraftCategoriesService)->

  @activities = [{}]
  @currentUser = null
  @loading = true

  @aircraft_categories = []

#  if $routeParams.search_id
#    $http.get("/searches/#{$routeParams.search_id}/get_for_index.json").success(
#      (data)=>
#        @activities = data
#        for activity in @activities
#          activity.start_at = Date.parse(activity.start_at)
#    )

  AircraftCategoriesService.getAircraftCategories().then(
    =>
      @aircraft_categories = AircraftCategoriesService.aircraft_categories
  )


  @signIn = ->
    CurrentUserService.openSignInModal('md')

  @signOut = ->
    CurrentUserService.signOut()

  @options = {
    barColor:'rgb(27,143,188)'
    scaleColor:false
    lineWidth:10
    lineCap:'circle'
    size: 220
    animate: 5000
    onStep: (from, to, current)->
      span = $(this.el).find('.percent')
      span.html("#{parseInt(current)}%")
  }

  $scope.$watch(
    =>
      @activities
  ,
    =>
      @formatActivities()
  ,
    true
  )

  $scope.$watch(
    =>
      CurrentUserService.currentUser
  ,
    =>
      @currentUser = CurrentUserService.currentUser
  )

  @airports = []

  @jetsteals = []

  @onSetTime = (newDate, oldDate, index)->
    if index + 1 == @activities.length
#do nothing
    else
      alert 'cannot change date'
      @activities[index].start_at  = oldDate

  @beforeRenderDate = (view, dates, leftDate, upDate, rightDate, index)->
#    Temp comment for create past trip

    activeDate = null
    if index > 0
      previous_activity = @activities[index-1]
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


  @formatActivities = ->
    previous = null
    for activity in @activities
      if previous
        activity.departure_airport = previous.arrival_airport
      previous = activity

  AirportsService.getAirports().then(
    =>
      @airports = AirportsService.airports
  )

  # fetching jetsteals
  @load_jetsteals = ()->
    arr = []
    $http.get('/jetsteals/get_list.json').success(
      (data)=>
        $.each(data, (i, v)=>
#          if !v.sold_out && arr.length < 2
          if arr.length < 4
            arr.push(v)
            @jetsteals = arr
        )
        @loading = false
    ).error(
      ->
        alert 'error fetching jetsteals, try again later'
    )

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, hh:mm A')
    if data and data == 'Invalid date'
      return 'Departure Date, Time'
    else
      return data

  @formatDate = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY')
    if data and data == 'Invalid date'
      return 'Departure Date, Time'
    else
      return data

  @addActivity = ->
    return unless @validatedActivities()
    @activities.push {}

  @addRoundTrip = ->
    return unless @validatedActivities()
    @activities.push {arrival_airport: @activities[0].departure_airport}

  @removeActivity = (index)->
    if index > 0
      @activities.splice index, 1

  @validatedActivities = ->
    for activity in @activities
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
    for activity in @activities
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

  @wed_enquiry = ->
    $uibModal.open(
      size: 'md'
      templateUrl: '/templates/enquiry_form_modal'
      controller: 'JetSetWedEnquiryController'
      controllerAs: 'ctrl'
      backdrop: true
    )

  @heli_set_go_enquiry = ->
    $uibModal.open(
      size: 'md'
      templateUrl: '/templates/enquiry_form_modal'
      controller: 'HeliSetGoEnquiryController'
      controllerAs: 'ctrl'
      backdrop: true
    )

  @yatra_enquiry = ->
    $uibModal.open(
      size: 'md'
      templateUrl: '/templates/enquiry_form_modal'
      controller: 'JetSetYatraEnquiryController'
      controllerAs: 'ctrl'
      backdrop: true
    )

  @rescue_enquiry = ->
    $uibModal.open(
      size: 'md'
      templateUrl: '/templates/enquiry_form_modal'
      controller: 'JetSetRescueEnquiryController'
      controllerAs: 'ctrl'
      backdrop: true
    )

  @aircraftCategoryForId = (id)->
    _.find(@aircraft_categories,{id: parseInt(id)})


  return undefined
]