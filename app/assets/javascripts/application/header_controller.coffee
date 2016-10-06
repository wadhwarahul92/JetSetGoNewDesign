jetsetgo_app.controller 'HeaderController', ['$http', 'notify', 'CurrentUserService', '$scope', '$routeParams', '$location', 'AircraftCategoriesService', ($http, notify, CurrentUserService, $scope, $routeParams, $location, AircraftCategoriesService)->

  @currentUser = null

  @isFromMobile = false

  @activeNav = true

  @active_menu = false

  @active_submenu = false

  @aircraft_categories = []

  path = $location.path()
  if path == '/requested_add_passenger'
    @activeNav = false

  if $routeParams.search_id
    $http.get("/searches/#{$routeParams.search_id}/get_for_index.json").success(
      (data)=>
        @activities = data
    )

  AircraftCategoriesService.getAircraftCategories().then(
    =>
      @aircraft_categories = AircraftCategoriesService.aircraft_categories
  )

  @signIn = ->
    CurrentUserService.openSignInModal('md')

#  @hideForPath = ->
#    if location.pathname == '/tmp_url'
#      return true

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

  @aircraftCategoryForId = (id)->
    _.find(@aircraft_categories,{id: parseInt(id)})

  return undefined
]