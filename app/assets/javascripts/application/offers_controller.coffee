jetsetgo_app.controller 'OffersController', ['$http', 'notify', ($http, notify)->

  @offers = {}

  #  $http.get('jetsteals/get_list.json').success(
  #    (data)=>
  #      @empty_legs_offered = data
  #  ).error(
  #    ->
  #      notify(
  #        message: 'Error fetching empty legs offered'
  #        classes: ['alert-danger']
  #      )
  #  )

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