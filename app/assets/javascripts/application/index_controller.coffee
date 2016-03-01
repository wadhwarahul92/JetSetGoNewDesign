jetsetgo_app.controller 'IndexController', ['$http', 'notify', 'AirportsService', ($http, notify, AirportsService)->

  @activities = [{}]

  @airports = []

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

  @create = ->
    console.log @activities

  return undefined
]