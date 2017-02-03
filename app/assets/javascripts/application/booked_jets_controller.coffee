jetsetgo_app.controller 'BookedJetsController', ['$http', 'notify', 'CurrentUserService', '$scope', '$location', 'CustomerCostBreakUpsService', ($http, notify, CurrentUserService, $scope, $location, CustomerCostBreakUpsService)->

  @jsg_commision = CustomerCostBreakUpsService.commission

  @currentUser = null

#  @enquired_jets = {}

  @booked_jets = {}

  @active_jetsteal = false

  @loading = true

#  @quotes = {}
#
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

  $http.get('/current_user.json').success(
    (data)=>
      scope.currentUser = data
  ).error(
    ->
      notify(
        message: 'not logged in'
        classes: ['alert-danger']
      )
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

#  $http.get('customers/get_booked_jets.json').success(
#    (data)=>
#      @booked_jets = data
#      for confirmed_jets in @booked_jets
#        confirmed_jets.grandTotal = CustomerCostBreakUpsService.totalTripCost(confirmed_jets)
#  ).error(
#    ->
#      notify(
#        message: 'Error fetching booked jets'
#        classes: ['alert-danger']
#      )
#  )

  $http.get('customers/get_confirmed_jetsteals.json').success(
    (data)=>

      @booked_jets = data
      for confirmed_jets in @booked_jets.trips
        confirmed_jets.grandTotal = CustomerCostBreakUpsService.totalTripCost(confirmed_jets)
      @loading = false
  ).error(
    ->
      notify(
        message: 'Error fetching booked jets'
        classes: ['alert-danger']
      )
  )


  @get_confirmed_trip_date = (trip)->
    con_date = trip.currentTarget.innerHTML
    $http.get('customers/get_confirmed_jetsteals.json', params:
      con_date: con_date).success(
      (data)=>

        @booked_jets = data
        for confirmed_jets in @booked_jets.trips
          confirmed_jets.grandTotal = CustomerCostBreakUpsService.totalTripCost(confirmed_jets)
        @loading = false
    ).error(
      ->
        notify(
          message: 'Error fetching booked jets'
          classes: ['alert-danger']
        )
    )


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

#  $http.get('/trips/get_quotes.json').success(
#    (data)=>
#      @quotes = data
#  ).error(
#    ->
#      notify
#        message: 'Error fetching quotes'
#        classes: ['alert-danger']
#  )

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

  @get_jetsteal_departure_date = (trip)->
    moment(trip.start_at).format('DD MMM YYYY, h:mm a');

  @include_commission = (cost)->
    cost + @jsg_commision/100 * cost

  @doMediaQuery = (trip)->
    trip.more_detail_active = true
    w = angular.element(window).width()
    if w < 768
      trip.more_detail_active = false

  return undefined
]