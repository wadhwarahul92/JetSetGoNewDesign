jetsetgo_app.controller 'HeaderController', ['$http', 'notify', 'CurrentUserService', '$scope', ($http, notify, CurrentUserService, $scope)->

  @currentUser = null

  @isFromMobile = false

  @hideForPath = ->
    if location.pathname == '/tmp_url'
      return true

  x = location.search.match(/\?isfrommobile=([a-z]+)/)
  if x != null && x[1] == 'yes'
    @isFromMobile = true

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