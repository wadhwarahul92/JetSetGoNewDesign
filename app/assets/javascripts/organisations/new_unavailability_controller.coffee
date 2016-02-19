organisations_app.controller 'NewUnavailabilityController', ['$http', 'notify', 'AircraftsService', '$scope', 'AircraftUnavailabilitiesService', ($http, notify, AircraftsService, $scope, AircraftUnavailabilitiesService)->

  @aircrafts = []

  AircraftsService.getAircraftsForCurrentOperator().then(
    =>
      @aircrafts = AircraftsService.aircraftsForCurrentOperator
  )

  @a_u = {}

  @formattedStartTime = null

  @formattedEndTime = null

  $scope.$watchCollection(
    =>
      @a_u
    ,
    =>
      @formattedStartTime = moment(new Date("#{@a_u.start_at}")).format('Do MMM YYYY, h:mm:ss A') if @a_u.start_at
      @formattedEndTime = moment(new Date("#{@a_u.end_at}")).format('Do MMM YYYY, h:mm:ss A') if @a_u.end_at
  )

  @create = ->
    $http.post("/organisations/aircraft_unavailabilities.json", @a_u).success(
      ->
        notify(
          message: 'Aircraft unavailability added.'
        )
        AircraftUnavailabilitiesService.deleteCache()
        Turbolinks.visit('/organisations/aircraft_unavailabilities')
    ).error(
      (data)->
        error = 'ERROR:AU_C_1 Something went wrong.'
        try
          error = data.errors[0]
        notify(
          message: error
          classes: ['alert-danger']
        )
    )

  return undefined
]