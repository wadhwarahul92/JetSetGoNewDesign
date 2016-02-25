jetsetgo_app.controller 'HeaderController', ['$http', 'notify', 'CurrentUserService', '$scope', ($http, notify, CurrentUserService, $scope)->

  @currentUser = null

  $scope.$watch(
    =>
      CurrentUserService.currentUser
    ,
    =>
      @currentUser = CurrentUserService.currentUser
  )

  @openSignInModal = ->
    CurrentUserService.openSignInModal()

  @signOut = ->
    CurrentUserService.signOut()

  @openSignUpModal = ->
    CurrentUserService.openSignUpModal()

  return undefined
]