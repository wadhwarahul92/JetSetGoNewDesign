jetsetgo_app.controller 'EnquiredJetsController', ['$http', 'notify', 'CurrentUserService', '$scope', 'CustomerCostBreakUpsService', ($http, notify, CurrentUserService, $scope, CustomerCostBreakUpsService)->

  @jsg_commision = CustomerCostBreakUpsService.commission

  @currentUser = null

  @enquired_jets = {}

  @loading = true

#  @booked_jets = {}
#
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
#        message: 'Error fetching user trips'
#        classes: ['alert-danger']
#      )
#  )
#
#
#  $http.get('/trips/get_quotes.json').success(
#    (data)=>
#      @quotes = data
#  ).error(
#    ->
#      notify
#        message: 'Error fetching quotes'
#        classes: ['alert-danger']
#  )

  $http.get('customers/get_enquired_jets.json').success(
    (data)=>
#      @enquired_jets = data
      @enquiries = data
      for enquiry in @enquiries
        enquiry.grandTotal = CustomerCostBreakUpsService.totalTripCost(enquiry)
      @loading = false
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

  @get_enquired_trip_date = (trip)->
    enq_date = trip.currentTarget.innerHTML
    $http.get('customers/get_enquired_jets.json', params:
      enq_date: enq_date).success(
      (data)=>
        @enquiries = data
        for enquiry in @enquiries
           enquiry.grandTotal = CustomerCostBreakUpsService.totalTripCost(enquiry)
        @loading = false
    ).error(
      ->
         notify(
          message: 'Error fetching enquired jets'
          classes: ['alert-danger']
      )
    )

  @get_dates = ()->
    $http.get("customers/get_dates.json").success(
      (data)=>
        @dates = data
    ).error(
      ->
        notify(
          message: "Error fetching dates"
          classes: ['alert-danger']
        )
    )


  @datecarousel = ->
    $('.about-carousel').owlCarousel
      items: 3
      navigation: true
      pagination: false
      navigationText: [
        '<i class=\'fa fa-angle-left\'></i>'
        '<i class=\'fa fa-angle-right\'></i>'
      ]
    return

  @include_commission = (cost)->
    cost + @jsg_commision/100 * cost

#  @count_empty_legs = (trips)->
#    count = 0
#    for trip in trips
#      for activity in trip.activities
#        if activity.empty_leg == true
#          count = count+1
#    return count

  @doMediaQuery = (enquiry)->
    enquiry.more_detail_active = true
    w = angular.element(window).width()
    if w < 768
      enquiry.more_detail_active = false

  return undefined
]