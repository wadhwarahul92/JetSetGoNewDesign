jetsetgo_app.controller 'QuotesController', ['$http', 'notify', '$scope', '$location', 'CurrentUserService', 'CustomerCostBreakUpsService', ($http, notify, $scope, $location, CurrentUserService, CustomerCostBreakUpsService)->

  @jsg_commision = CustomerCostBreakUpsService.commission

  @currentUser = null

#  @enquired_jets = {}
#
#  @booked_jets = {}

  @quotes = {}

  @loading = true

#  @trips = {}

  $scope.$watch(
    =>
      CurrentUserService.currentUser
  ,
    =>
      @currentUser = CurrentUserService.currentUser
  )

  scope = this

  setTimeout(
    ->
      unless scope.currentUser
        location.replace('/')
  ,
    1500
  )

#  $http.get('customers/get_enquired_jets.json').success(
#    (data)=>
#      @enquired_jets = data
#  ).error(
#    ->
#      notify(
#        message: 'Error fetching enquired jets'
#        classes: ['alert-danger']
#      )
#  )
#
#  $http.get('customers/get_booked_jets.json').success(
#    (data)=>
#      @booked_jets = data
#  ).error(
#    ->
#      notify(
#        message: 'Error fetching booked jets'
#        classes: ['alert-danger']
#      )
#  )
#
#  $http.get('customers/get_user_trips.json').success(
#    (data)=>
#      @trips = data
#  ).error(
#    ->
#      notify(
#        message: 'Error fetching trips'
#        classes: ['alert-danger']
#      )
#  )

  $http.get('/trips/get_quotes.json').success(
    (data)=>
      @quotes = data
      for quote in @quotes
        quote.grandTotal = CustomerCostBreakUpsService.totalTripCost(quote)
      @loading = false
  ).error(
    ->
      notify
        message: 'Error fetching quotes'
        classes: ['alert-danger']
  )

  @count_empty_legs = (trips)->
    count = 0
    for trip in trips
      for activity in trip.activities
        if activity.empty_leg == true
          count = count+1
    return count

  @get_departure_date = (trip)->
    for activity in trip.activities
      if !activity.empty_leg
        return activity.start_at

  @include_commission = (cost)->
    cost + @jsg_commision/100 * cost

  @doMediaQuery = (quote)->
    quote.more_detail_active = true
    w = angular.element(window).width()
    if w < 768
      quote.more_detail_active = false

  return undefined
]