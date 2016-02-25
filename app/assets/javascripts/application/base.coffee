window.jetsetgo_app = angular.module 'jetsetgo_app', [
  'angular-loading-bar'
  'cgNotify'
  'ui.bootstrap'
]

jetsetgo_app.run ['notify', (notify)->
  notify.config(
    maximumOpen: 1
  )
]