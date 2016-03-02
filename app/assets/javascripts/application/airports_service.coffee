jetsetgo_app.factory 'AirportsService', ['$http', 'notify', '$q', ($http, notify, $q)->

  serviceInstance = {}

  serviceInstance.airports = null

  serviceInstance.getAirports = ->
    if serviceInstance.airports
      deffered = $q.defer()
      deffered.resolve(serviceInstance.airports)
      return deffered.promise
    else
      promise = $http.get('/airports.json')
      promise.success(
        (data)->
          serviceInstance.airports = data
      ).error(
        ->
          notify
            message: 'Error fetching airports'
            classes: ['alert-danger']
      )
      return promise

  return serviceInstance
]