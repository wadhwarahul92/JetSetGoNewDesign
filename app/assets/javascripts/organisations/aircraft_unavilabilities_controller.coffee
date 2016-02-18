organisations_app.controller 'AircraftUnavailabilitiesController', ['$http', 'notify', ($http, notify)->

  @events = []

#  $http.get('/organisations/aircraft_unavailabilities.json').success(
#    (data)=>
#      @events = data
#      $('#unavailabilities_calendar').fullCalendar({
#        events: @events
#      })
#  ).error(
#    ->
#      notify(
#        message: 'ERROR fetching aircraft unavilabilities'
#        classes: ['alert-danger']
#      )
#  )

  return undefined
]