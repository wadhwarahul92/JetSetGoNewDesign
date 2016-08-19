jetsetgo_app.controller 'QuotesController', ['$http', 'notify', '$scope', '$location', 'CurrentUserService', 'CustomerCostBreakUpsService', ($http, notify, $scope, $location, CurrentUserService, CustomerCostBreakUpsService)->

  @jsg_commision = CustomerCostBreakUpsService.commission

  @currentUser = null

#  @enquired_jets = {}
#
#  @booked_jets = {}

  @quotes = {}

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
        location.replace('tmp_url')
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

  return undefined
]