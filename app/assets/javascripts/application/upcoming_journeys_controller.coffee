jetsetgo_app.controller 'UpcomingJourneysController', ['$http', 'notify', ($http, notify)->

  @upcoming_journeys = {}

  $http.get('customers/get_upcoming_journeys.json').success(
    (data)=>
      @upcoming_journeys = data
  ).error(
    ->
      notify(
        message: 'Error fetching booked jets'
        classes: ['alert-danger']
      )
  )

  return undefined
]