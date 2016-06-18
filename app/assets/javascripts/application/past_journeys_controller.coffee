jetsetgo_app.controller 'PastJourneysController', ['$http', 'notify', ($http, notify)->

  @past_journeys = {}

  $http.get('customers/get_past_journeys.json').success(
    (data)=>
      @past_journeys = data
  ).error(
    ->
      notify(
        message: 'Error fetching booked jets'
        classes: ['alert-danger']
      )
  )

  return undefined
]