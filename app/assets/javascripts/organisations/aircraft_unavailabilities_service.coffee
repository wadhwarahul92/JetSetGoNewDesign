organisations_app.factory 'AircraftUnavailabilitiesService', ['$http', 'notify', '$q', ($http, notify, $q)->

  serviceInstance = {}

  serviceInstance.deleteCache = ->
    sessionStorage.removeItem('aircraft_unavailabilities')

  serviceInstance.setUnavailabilitiesForCurrentOperator = (array)->
    serviceInstance.unavailabilities = array
    try
      sessionStorage.setItem('aircraft_unavailabilities', JSON.stringify(array))

  serviceInstance.init = ->
    data = null
    try
      data = JSON.parse( sessionStorage.getItem('aircraft_unavailabilities') )
    serviceInstance.unavailabilities = data if data

  serviceInstance.getUnavailabilitiesForCurrentOperator = ->
    serviceInstance.init() unless serviceInstance.unavailabilities
    if serviceInstance.unavailabilities
      deffered = $q.defer()
      deffered.resolve(serviceInstance.unavailabilities)
      return deffered.promise
    else
      promise = $http.get('/organisations/aircraft_unavailabilities.json')
      promise.success(
        (data)->
          serviceInstance.setUnavailabilitiesForCurrentOperator(data)
      ).error(
        ->
          notify(
            message: 'Error fetching unavailabilities. Error: 2x100'
            classes: ['alert-danger']
          )
      )
      return promise

  return serviceInstance
]