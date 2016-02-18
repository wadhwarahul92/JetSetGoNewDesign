organisations_app.controller 'AircraftUnavailabilitiesController', ['$http', 'notify', '$scope', ($http, notify, $scope)->

  @eventsSources = []

  $scope.eventClicked = (event, jsEvent, view)->
    console.log jsEvent

  $http.get('/organisations/aircraft_unavailabilities.json').success(
    (data)=>
      @eventsSources.push data
  ).error(
    ->
      notify(
        message: 'ERROR fetching aircraft unavilabilities'
        classes: ['alert-danger']
      )
  )

  @calendarConfig = {
    calendar: {
      eventClick: $scope.eventClicked
    }
  }

  return undefined
]