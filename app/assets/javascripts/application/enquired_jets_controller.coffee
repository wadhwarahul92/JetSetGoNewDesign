jetsetgo_app.controller 'EnquiredJetsController', ['$http', 'notify', ($http, notify)->

  @enquired_jets = {}

  $http.get('customers/get_enquired_jets.json').success(
    (data)=>
      @enquired_jets = data
  ).error(
    ->
      notify(
        message: 'Error fetching enquired jets'
        classes: ['alert-danger']
      )
  )

  return undefined
]