jetsetgo_app.controller 'OurFleetController', ['$http', '$routeParams', 'AircraftCategoriesService', ($http, $routeParams, AircraftCategoriesService)->

  @fleet_detail = false

  @aircrafts = []

  @aircraft_categories = []

  @aircraft_category = null

  @id = 12

  AircraftCategoriesService.getAircraftCategories().then(
    =>
      @aircraft_categories = AircraftCategoriesService.aircraft_categories

      @aircraft_category = @aircraftCategoryForId(@id)
  )

  #  $http.get("get_fleets/#{$routeParams.id}.json").success(
  $http.get("get_fleets/#{@id}.json").success(
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
    _.find(@aircraft_categories, {id: id})

  return undefined
]