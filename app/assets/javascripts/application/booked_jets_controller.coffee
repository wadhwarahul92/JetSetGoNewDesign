jetsetgo_app.controller 'BookedJetsController', ['$http', 'notify', ($http, notify)->

  @booked_jets = {}

  $http.get('customers/get_booked_jets.json').success(
    (data)=>
      @booked_jets = data
  ).error(
    ->
      notify(
        message: 'Error fetching booked jets'
        classes: ['alert-danger']
      )
  )

  return undefined
]