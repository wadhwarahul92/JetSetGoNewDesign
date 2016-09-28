jetsetgo_app.factory 'AircraftCategoriesService', ['$http', 'notify', ($http, notify)->

  serviceInstance = {}

  serviceInstance.aircraft_categories = []

  serviceInstance.getAircraftCategories = ->
    promise = $http.get('/aircraft_categories.json')
    promise.success(
      (data)->
        if serviceInstance.aircraft_categories.length < 1
          if data and data[0]
            for aircraft_category in data
              serviceInstance.aircraft_categories.push aircraft_category
    ).error(
      ->
        notify
          message: 'Error fetching aircraft categories.1x10097'
          classes: ['alert-danger']
    )
    return promise

  return serviceInstance
]