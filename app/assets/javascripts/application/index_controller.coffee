jetsetgo_app.controller 'IndexController', ['$http', 'notify', 'AirportsService', '$scope', ($http, notify, AirportsService, $scope)->

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

  @setDepartureAirportId = (activity, departureAirport)->
    console.log activity

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
    console.log _activities

  return undefined
]