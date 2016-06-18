jetsetgo_app.controller 'BookedJetsController', ['$http', 'notify',($http, notify)->

  @booked_jets = {}

  $http.get('customers/booked_jets').success(
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