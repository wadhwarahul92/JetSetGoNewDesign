jetsetgo_app.controller 'SellEmptyLegController', ['$http', 'notify', 'CurrentUserService', '$scope', '$location', 'CustomerCostBreakUpsService', ($http, notify, CurrentUserService, $scope, $location, CustomerCostBreakUpsService)->

  @currentUser = null

  @jetsteals = {}

  $scope.$watch(
    =>
      CurrentUserService.currentUser
  ,
    =>
      @currentUser = CurrentUserService.currentUser
  )

  scope = this

  setTimeout(
    ->
      unless scope.currentUser
        location.replace('tmp_url')
  ,
    1500
  )

#  $http.get('customers/get_confirmed_jetsteals.json').success(
#    (data)=>
#      @jetsteals = data
#  ).error(
#    ->
#      notify(
#        message: 'Error fetching booked jets'
#        classes: ['alert-danger']
#      )
#  )



  return undefined
]