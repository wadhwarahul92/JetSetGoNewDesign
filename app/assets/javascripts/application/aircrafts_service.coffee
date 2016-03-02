jetsetgo_app.factory 'AircraftsService', ['$http', 'notify', ($http, notify)->

  serviceInstance = {}

  serviceInstance.aircrafts = []

  serviceInstance.getAircraftsForIds = (aircraft_ids)->
    unavailable_aircrafts_ids = []
    for aircraft_id in aircraft_ids
      unless _.find(serviceInstance.aircrafts, {id: aircraft_id})
        unavailable_aircrafts_ids.push aircraft_id
    promise = $http.post('/aircrafts.json', {ids: unavailable_aircrafts_ids})
    promise.success(
      (data)->
        if data and data[0]
          for aircraft in data
            serviceInstance.aircrafts.push aircraft
    ).error(
      ->
        notify
          message: 'Error fetching aircrafts.1x10097'
          classes: ['alert-danger']
    )
    return promise

  return serviceInstance
]