jetsetgo_app.controller 'HeaderController', ['$http', 'notify', 'CurrentUserService', '$scope', '$routeParams', ($http, notify, CurrentUserService, $scope, $routeParams)->

  @currentUser = null

  @isFromMobile = false


  if $routeParams.search_id
    $http.get("/searches/#{$routeParams.search_id}/get_for_index.json").success(
      (data)=>
        @activities = data
    )

  @signIn = ->
    CurrentUserService.openSignInModal('md')

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
    CurrentUserService.openSignUpModal('md')

  return undefined
]