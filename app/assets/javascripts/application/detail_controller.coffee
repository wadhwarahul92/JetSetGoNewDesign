jetsetgo_app.controller 'DetailController', ['$http', 'notify', '$routeParams', 'CurrentUserService', '$scope', ($http, notify, $routeParams, CurrentUserService, $scope)->

  @trip_id = $routeParams.id

  @trip = {}

  @currentUser = null

  $scope.$watch(
    =>
      CurrentUserService.currentUser
    ,
    =>
      @currentUser = CurrentUserService.currentUser
  )

  $http.get("trips/#{@trip_id}.json").success(
    (data)=>
      @trip = data
  ).error(
    ->
      notify(
        massege: 'Error fetching trip'
        classes: ['alert-danger']
      )
  )

  @set_sell_empty_leg = ->
    $http.put('customers/set_sell_empty_leg.json',{trip_id: @trip.id, sell_empty_leg: @trip.sell_empty_leg}).success(
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