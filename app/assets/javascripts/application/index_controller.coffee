jetsetgo_app.controller 'IndexController', ['$http', 'notify', 'AirportsService', '$scope', '$location', ($http, notify, AirportsService, $scope, $location)->

  @activities = [{}]

  $scope.$watch(
    =>
      @activities
    ,
    =>
      @formatActivities()
    ,
    true
  )

  @airports = []

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

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, h:mm:ss A')
    if data and data == 'Invalid date'
      return 'Click to choose time'
    else
      return data

  @addActivity = ->
    @activities.push {}

  @removeActivity = (index)->
    if index > 0
      @activities.splice index, 1

  @validatedActivities = ->
    for activitiy in @activities
      unless activitiy.departure_airport
        notify
          message: 'Departure cannot be blank.'
          classes: ['alert-danger']
        return false
      unless activitiy.arrival_airport
        notify
          message: 'Arrival cannot be blank'
          classes: ['alert-danger']
        return false
      unless activitiy.start_at
        notify
          message: 'Time cannot be blank.'
          classes: ['alert-danger']
        return false
      unless activitiy.pax
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

  return undefined
]