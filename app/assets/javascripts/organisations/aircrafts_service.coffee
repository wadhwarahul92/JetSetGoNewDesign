organisations_app.factory 'AircraftsService', ['$http', 'notify', '$q', ($http, notify, $q)->

  serviceInstance = {}

  serviceInstance.deleteCache = ->
    sessionStorage.removeItem('aircraftsForCurrentOperator')

  serviceInstance.setAircraftsForCurrentOperator = (array)->
    serviceInstance.aircraftsForCurrentOperator = array
    try
      # todo make alternate and consistent storage tech
      # sessionStorage.setItem('aircraftsForCurrentOperator', JSON.stringify(array))

  serviceInstance.init = ->
    if sessionStorage
      data = null
      try
        data = JSON.parse sessionStorage.getItem('aircraftsForCurrentOperator')
      serviceInstance.aircraftsForCurrentOperator = data if data

  # most not be called directly, to get aircrafts call #getAircraftsForCurrentOperator
  serviceInstance.aircraftsForCurrentOperator = null

  serviceInstance.getAircraftsForCurrentOperator = ->
    serviceInstance.init() unless serviceInstance.aircraftsForCurrentOperator
    if serviceInstance.aircraftsForCurrentOperator
      deffered = $q.defer()
      deffered.resolve(serviceInstance.aircraftsForCurrentOperator)
      return deffered.promise
    else
      promise = $http.get('/organisations/aircrafts.json')
      promise.success(
        (data)->
          serviceInstance.setAircraftsForCurrentOperator(data)
      ).error(
        ->
          notify(
            message: 'Error fetching aircrafts. Error: 1x100'
            classes: ['alert-danger']
          )
      )
      return promise

  return serviceInstance
]