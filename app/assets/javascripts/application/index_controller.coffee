jetsetgo_app.controller 'IndexController', ['$http', 'notify', 'AirportsService', ($http, notify, AirportsService)->

  @activities = [{}]

  @airports = []

  AirportsService.getAirports().then(
    =>
      @airports = AirportsService.airports
  )

  @create = ->
    console.log @activities

  return undefined
]