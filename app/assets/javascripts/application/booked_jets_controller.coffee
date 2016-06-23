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

  @set_sell_empty_leg = (booked_jet)->
    $http.put('customers/set_sell_empty_leg.json',{trip_id: booked_jet.id, sell_empty_leg: booked_jet.sell_empty_leg}).success(
      ->
        notify(
          message: 'successfully saved.'
        )
    ).error(
      (data)=>
        notify(
          massege: data.errors[0]
          classes: ['alert-danger']
        )

    )

  return undefined
]