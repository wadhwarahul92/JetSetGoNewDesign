organisations_app.controller 'AircraftUnavailabilitiesController', ['$http', 'notify', '$scope', 'AircraftsService', 'AircraftUnavailabilitiesService', ($http, notify, $scope, AircraftsService, AircraftUnavailabilitiesService)->

  @aircrafts = []

  AircraftsService.getAircraftsForCurrentOperator().then(
    =>
      @aircrafts = AircraftsService.aircraftsForCurrentOperator
  )

  @showCard = ->
    try
#      card = $('#unavailability_card')
#      card.removeClass('bounceOutRight')
#      card.addClass('unavailability_card')
#      card.addClass('bounceInRight')
    null

  @hideCard = ->
    try
#      card = $('#unavailability_card')
#      card.removeClass('bounceInRight')
#      card.addClass('unavailability_card')
#      card.addClass('bounceOutRight')
    null

  @neutralizeCard = ->
    try
#      card = $('#unavailability_card')
#      card.removeClass('bounceInRight')
    null

  @eventsSources = []

  @selectedEvent = null

  @a_u = {}

  @formattedStartTime = null

  @formattedEndTime = null

  scope = this

  @delete = ->
    return unless @a_u
    bootbox.confirm('Are you sure?', (result)=>
      if result
        $http.delete("/organisations/aircraft_unavailabilities/#{@a_u.id}").success(
          =>
            AircraftUnavailabilitiesService.deleteCache()
            location.reload()
        ).error(
          (data)->
            error = 'Something went wrong'
            try
              error = data.errors[0]
            notify(
              message: error
              classes: ['alert-danger']
            )
        )
    )
    null

  @update = ->
    $http.put("/organisations/aircraft_unavailabilities/#{@a_u.id}", @a_u).success(
      (data)->
        AircraftUnavailabilitiesService.deleteCache()
        location.reload()
    ).error(
      (data)->
        error = 'Something went wrong'
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
        scope.showCard()
        scope.a_u = data
    ).error(
      ->
        notify(
          message: 'Error fetching data: a_u'
          classes: ['alert-danger']
        )
    )

  AircraftUnavailabilitiesService.getUnavailabilitiesForCurrentOperator().then(
    =>
      @eventsSources.push AircraftUnavailabilitiesService.unavailabilities
  )

#  $http.get('/organisations/aircraft_unavailabilities.json').success(
#    (data)=>
#      @eventsSources.push data
#  ).error(
#    ->
#      notify(
#        message: 'ERROR fetching aircraft unavilabilities'
#        classes: ['alert-danger']
#      )
#  )

  @calendarConfig = {
    calendar: {
      header:{
        center: 'month,agendaWeek'
      }
      eventClick: $scope.eventClicked
    }
  }

  @hideCard()

  return undefined
]