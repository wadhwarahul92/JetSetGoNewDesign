jetsetgo_app.controller 'EmptyLegsOfferedController', ['$http', 'notify', ($http, notify)->

  @empty_legs_offered = {}

  $http.get('jetsteals/get_list.json').success(
    (data)=>
      @empty_legs_offered = data
  ).error(
    ->
      notify(
        message: 'Error fetching empty legs offered'
        classes: ['alert-danger']
      )
  )

  return undefined
]