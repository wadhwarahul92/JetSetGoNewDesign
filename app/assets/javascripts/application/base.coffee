window.jetsetgo_app = angular.module 'jetsetgo_app', [
  'angular-loading-bar'
  'cgNotify'
  'ui.bootstrap'
  'ngRoute'
  'ui.bootstrap.datetimepicker'
]

jetsetgo_app.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider)->

  $routeProvider.when('/', {
    templateUrl: '/templates/index'
    controller: 'IndexController'
    controllerAs: 'ctrl'
  })

  $locationProvider.html5Mode(true)

  return undefined
]

jetsetgo_app.run ['notify', (notify)->
  notify.config(
    maximumOpen: 1
  )
]