jetsetgo_app.controller 'OurFleetController', ['$http', '$routeParams', 'AircraftCategoriesService', ($http, $routeParams, AircraftCategoriesService)->

  @fleet_detail = false

  @aircrafts = []

  @aircraft_categories = []

  @aircraft_category = null

  @id = $routeParams.id

  AircraftCategoriesService.getAircraftCategories().then(
    =>
      @aircraft_categories = AircraftCategoriesService.aircraft_categories

      @aircraft_category = @aircraftCategoryForId(@id)
  )

  #  $http.get("get_fleets/#{$routeParams.id}.json").success(
  $http.get("our_fleet/#{@id}.json").success(
    (data)=>
      @aircrafts = data
    ).error(
    ->
      notify(
        massege: 'Error fetching aircrafts'
        classes: ['alert-danger']
      )
  )

  @aircraftCategoryForId = (id)->
    _.find(@aircraft_categories,{id: parseInt(id)})

  @doMediaQuery = (result)->
    result.more_detail_active = true
    w = angular.element(window).width()
    if w < 768
      result.more_detail_active = false

  return undefined
]