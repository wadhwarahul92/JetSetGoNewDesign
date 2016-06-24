jetsetgo_app.controller 'OffersController', ['$http', 'notify', ($http, notify)->

  @offers = {}

  $http.get('customers/get_offers.json').success(
    (data)=>
      @offers = data
  ).error(
    ->
      notify(
        message: 'Error fetching offers'
        classes: ['alert-danger']
      )
  )

  return undefined
]