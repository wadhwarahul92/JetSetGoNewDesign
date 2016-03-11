angular.module('CustomFilters', []).filter('indianCurrency', ->
  return (input)->
    return input unless input
    numberPart = input.split('.')[0]
    decimalPart = input.split('.')[1]
    numberPart = numberPart.replace(/,/g, '')
    lastThree = numberPart.substring(numberPart.length-3)
    otherNumbers = numberPart.substring(0,numberPart.length-3)
    if(otherNumbers != '')
      lastThree = ',' + lastThree
    if decimalPart
      otherNumbers.replace(/\B(?=(\d{2})+(?!\d))/g, ",") + lastThree + '.' + decimalPart
    else
      otherNumbers.replace(/\B(?=(\d{2})+(?!\d))/g, ",") + lastThree
)

window.jetsetgo_app = angular.module 'jetsetgo_app', [
  'angular-loading-bar'
  'cgNotify'
  'ui.bootstrap'
  'ngRoute'
  'ui.bootstrap.datetimepicker'
  'CustomFilters'
]

jetsetgo_app.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider)->

  $routeProvider.when('/', {
    templateUrl: '/templates/index'
    controller: 'IndexController'
    controllerAs: 'ctrl'
  }).when('/searches/:id', {
    templateUrl: '/templates/search'
    controller: 'SearchController'
    controllerAs: 'ctrl'
  }).when('/about_us', {
    templateUrl: '/templates/about_us'
  }).when('/jet_set_wed', {
    templateUrl: '/templates/jet_set_wed'
  }).when('/heli_set_go', {
    templateUrl: '/templates/heli_set_go'
  }).when('/jet_set_yatra', {
    templateUrl: '/templates/jet_set_yatra'
  }).when('/media', {
    templateUrl: '/templates/media'
  }).when('/jet_setters', {
    templateUrl: '/templates/jet_setters'
  }).when('/contact_us', {
    templateUrl: '/templates/contact_us'
    controller: 'ContactUsController'
    controllerAs: 'ctrl'
  }).when('/our_edge', {
    templateUrl: '/templates/our_edge'
  }).when('/join_us', {
    templateUrl: '/templates/join_us'
  }).when('/terms_of_use', {
    templateUrl: '/templates/terms_of_use'
  }).when('/privacy_policy', {
    templateUrl: '/templates/privacy_policy'
  }).when('/quotes', {
    templateUrl: '/templates/quotes'
    controller: 'QuotesController'
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