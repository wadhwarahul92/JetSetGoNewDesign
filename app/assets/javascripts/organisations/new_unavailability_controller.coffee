organisations_app.controller 'NewUnavailabilityController', ['$http', 'notify', 'AircraftsService', ($http, notify, AircraftsService)->

  @aircrafts = []

  AircraftsService.getAircraftsForCurrentOperator().then(
    =>
      @aircrafts = AircraftsService.aircraftsForCurrentOperator
  )

  @a_u = {}

  @create = ->
    console.log(@a_u)

  return undefined
]