jetsetgo_app.controller 'EnquiredJetsController', ['$http', 'notify', 'CurrentUserService', '$scope', 'CustomerCostBreakUpsService', ($http, notify, CurrentUserService, $scope, CustomerCostBreakUpsService)->

  @jsg_commision = CustomerCostBreakUpsService.commission

  @enquired_jets = {}

  @currentUser = null

  #  @subTotal = 0.0
  @grandTotal = 0.0

  @enquired_jets = {}

  @booked_jets = {}

  @quotes = {}

  @trips = {}

  $http.get('customers/get_enquired_jets.json').success(
    (data)=>
      @enquired_jets = data
  ).error(
    ->
      notify(
        message: 'Error fetching enquired jets'
        classes: ['alert-danger']
      )
  )

  $http.get('customers/get_booked_jets.json').success(
    (data)=>
      @booked_jets = data
  ).error(
    ->
      notify(
        message: 'Error fetching booked jets'
        classes: ['alert-danger']
      )
  )

  $http.get('customers/get_user_trips.json').success(
    (data)=>
      @trips = data
  ).error(
    ->
      notify(
        message: 'Error fetching booked jets'
        classes: ['alert-danger']
      )
  )


  $http.get('/trips/get_quotes.json').success(
    (data)=>
      @quotes = data
  ).error(
    ->
      notify
        message: 'Error fetching quotes'
        classes: ['alert-danger']
  )


  $scope.$watch(
    =>
      CurrentUserService.currentUser
  ,
    =>
      @currentUser = CurrentUserService.currentUser
  )

  $http.get('customers/get_enquired_jets.json').success(
    (data)=>
#      @enquired_jets = data
      @enquiries = data
      for enquiry in @enquiries
        enquiry.grandTotal = CustomerCostBreakUpsService.totalTripCost(enquiry)

  ).error(
    ->
      notify(
        message: 'Error fetching enquired jets'
        classes: ['alert-danger']
      )
  )

  @get_departure_date = (trip)->
    for activity in trip.activities
      if !activity.empty_leg
        return activity.start_at

  @include_commission = (cost)->
    cost + @jsg_commision/100 * cost

  @calculateCost = (result)->
##    @subTotal = CustomerCostBreakUpsService.subTotal(result)
#    result.grandTotal = 0.0
#    result.grandTotal = CustomerCostBreakUpsService.totalTripCost(result)

  @count_empty_legs = (trips)->
    count = 0
    for trip in trips
      for activity in trip.activities
        if activity.empty_leg == true
          count = count+1
    return count


  return undefined
]