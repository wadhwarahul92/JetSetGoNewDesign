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
  'angularFileUpload'
  'ui.bootstrap'
  'ngRoute'
  'ui.bootstrap.datetimepicker'
  'CustomFilters'
  'noCAPTCHA'
  'easypiechart'
  'Services_app'
]

jetsetgo_app.config ['$routeProvider', '$locationProvider', 'noCAPTCHAProvider', ($routeProvider, $locationProvider, noCaptchaProvider)->

  $routeProvider.when('/', {
    templateUrl: '/templates/index'
    controller: 'IndexController'
    controllerAs: 'ctrl'
    #todo remove temporary path
  }).when('/tmp_url', {
    templateUrl: '/templates/index'
    controller: 'IndexController'
    controllerAs: 'ctrl'
  }).when('/searches/:id', {
    templateUrl: '/templates/search'
    controller: 'SearchController'
    controllerAs: 'ctrl'
  }).when('/about_us', {
    templateUrl: '/templates/about_us'
    controller: 'AboutUsController'
    controllerAs: 'ctrl'
  }).when('/jet_set_wed', {
    templateUrl: '/templates/jet_set_wed'
    controller: 'JetSetWedController'
    controllerAs: 'ctrl'
  }).when('/heli_set_go', {
    templateUrl: '/templates/heli_set_go'
    controller: 'HeliSetGoController'
    controllerAs: 'ctrl'
  }).when('/jet_set_yatra', {
    templateUrl: '/templates/jet_set_yatra'
    controller: 'JetSetYatraController'
    controllerAs: 'ctrl'
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
  }).when('/jet_set_rescue', {
    templateUrl: '/templates/jet_set_rescue'
    controller: 'JetSetRescueController'
    controllerAs: 'ctrl'
  }).when('/forget_password', {
    templateUrl: '/templates/forget_password'
    controller: 'ForgetPasswordController'
    controllerAs: 'ctrl'
  }).when('/profile', {
    templateUrl: '/templates/profile'
    controller: 'ProfileController'
    controllerAs: 'ctrl'
  }).when('/booked_jets', {
    templateUrl: '/templates/booked_jets'
    controller: 'BookedJetsController'
    controllerAs: 'ctrl'
  }).when('/upcoming_journeys', {
    templateUrl: '/templates/upcoming_journeys'
    controller: 'UpcomingJourneysController'
    controllerAs: 'ctrl'
  }).when('/past_journeys', {
    templateUrl: '/templates/past_journeys'
    controller: 'PastJourneysController'
    controllerAs: 'ctrl'
  }).when('/enquired_jets', {
    templateUrl: '/templates/enquired_jets'
    controller: 'EnquiredJetsController'
    controllerAs: 'ctrl'
  }).when('/offers', {
    templateUrl: '/templates/offers'
    controller: 'OffersController'
    controllerAs: 'ctrl'
  }).when('/passenger_details/:id', {
    templateUrl: '/templates/passenger_details'
    controller: 'PassengerDetailsController'
    controllerAs: 'ctrl'
  }).when('/detail/:id', {
    templateUrl: '/templates/detail'
    controller: 'DetailController'
    controllerAs: 'ctrl'
  }).when('/sell_empty_leg', {
    templateUrl: '/templates/sell_empty_leg'
    controller: 'SellEmptyLegController'
    controllerAs: 'ctrl'
  }).when('/requested_add_passenger', {
    templateUrl: '/templates/requested_add_passenger'
    controller: 'RequestedAddPassengerController'
    controllerAs: 'ctrl'
  }).when('/tmp_send_sms', {
    templateUrl: '/templates/tmp_send_sms'
    controller: 'TmpSendSmsController'
    controllerAs: 'ctrl'
  }).when('/our_fleet', {
    templateUrl: '/templates/our_fleet'
    controller: 'OurFleetController'
    controllerAs: 'ctrl'
  })



  $locationProvider.html5Mode(true)

  noCaptchaProvider.setSiteKey('6LcF2RoTAAAAABZsp4msdsOCYJZ6eDkEG_sIdTF8');
  noCaptchaProvider.setTheme('light');

  return undefined
]

jetsetgo_app.run ['notify', (notify)->
  notify.config(
    maximumOpen: 1
  )
]