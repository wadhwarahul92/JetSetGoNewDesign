jetsetgo_app.controller 'EnquiredJetsController', ['$http', 'notify', 'CurrentUserService', '$scope', ($http, notify, CurrentUserService, $scope)->

  @enquired_jets = {}

  @currentUser = null

  $scope.$watch(
    =>
      CurrentUserService.currentUser
    ,
    =>
      @currentUser = CurrentUserService.currentUser
  )

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