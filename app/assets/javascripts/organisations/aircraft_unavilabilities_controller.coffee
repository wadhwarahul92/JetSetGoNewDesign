organisations_app.controller 'AircraftUnavailabilitiesController', ['$http', 'notify', '$scope', 'AircraftsService', ($http, notify, $scope, AircraftsService)->

  @aircrafts = []

  AircraftsService.getAircraftsForCurrentOperator().then(
    =>
      @aircrafts = AircraftsService.aircraftsForCurrentOperator
  )

  @eventsSources = []

  @selectedEvent = null

  @a_u = {}

  @formattedStartTime = null

  @formattedEndTime = null

  scope = this

  @update = ->
    $http.put("/organisations/aircraft_unavailabilities/#{@a_u.id}", @a_u).success(
      (data)->
        events = scope.eventsSources[0]
        if events
          event = _.find(events, {id: data.id})
          if event
            event.start = data.start_at
            event.end = data.end_at
            scope.selectedEvent = null
    ).error(
      (data)->
        error = 'Something went worng'
        try
          error = data.errors[0]
        notify(
          message: error
          classes: ['alert-danger']
        )
    )

  $scope.$watchCollection(
    =>
      @a_u
  ,
    =>
      @formattedStartTime = moment(new Date("#{@a_u.start_at}")).format('Do MMM YYYY, h:mm:ss A') if @a_u.start_at
      @formattedEndTime = moment(new Date("#{@a_u.end_at}")).format('Do MMM YYYY, h:mm:ss A') if @a_u.end_at
  )

  $scope.eventClicked = (event, jsEvent, view)->
    scope.selectedEvent = event
    $http.get("/organisations/aircraft_unavailabilities/#{scope.selectedEvent.id}.json").success(
      (data)->
        scope.a_u = data
    ).error(
      ->
        notify(
          message: 'Error fetching data: a_u'
          classes: ['alert-danger']
        )
    )

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