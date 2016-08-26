jetsetgo_app.controller 'DetailController', ['$http', 'notify', '$routeParams', 'CurrentUserService', '$scope', 'CustomerCostBreakUpsService', ($http, notify, $routeParams, CurrentUserService, $scope, CustomerCostBreakUpsService)->

  @jsg_commision = CustomerCostBreakUpsService.commission

  @trip_id = $routeParams.id

  @trip = {}

  @enquired_jets = {}

  @booked_jets = {}

  @quotes = {}

  @trips = {}

  @currentUser = null

  @passenger_details = []

  @passenger_details_ = [{}]

  @catering = ''

  @journey = true

  @flight = true

  @cost = true

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
        location.path('tmp_url')
  ,
    1500
  )

  $http.get("get_passenger_datails/#{@trip_id}.json").success(
    (data)=>
      @passenger_details = data
  ).error(
    ->
      notify(
        massege: 'Error fetching passenger details'
        classes: ['alert-danger']
      )
  )

  $http.get("trips/#{@trip_id}.json").success(
    (data)=>
      @trip = data
      if @trip.status == 'confirmed'
        @journey = false
        @flight = false
        @cost = false
      @catering =  @trip.catering
      @trip.total_flight_cost = 0.0
      @trip.total_landing_cost = 0.0
      @trip.total_ground_handling_cost = 0.0
#      @trip.total_accomodation_charge = 0.0
      @trip.set_watch_hour = false
      @trip.total_flight_time = ''
      @trip.total_accommodation_cost = 0.0
      @trip.total_accommodation_nights = 0
      for activity in @trip.activities
        @trip.total_flight_cost += activity.flight_cost
        @trip.total_landing_cost += activity.landing_cost_at_arrival
        @trip.total_ground_handling_cost += activity.handling_cost_at_takeoff
        if activity.accommodation_plan
          @trip.total_accommodation_nights += activity.accommodation_plan.nights
          @trip.total_accommodation_cost += activity.accommodation_plan.cost * activity.accommodation_plan.nights
        if activity.watch_hour_at_arrival
          @trip.set_watch_hour = true
        activity.flight_time = moment.duration(new Date(activity.end_at) - new Date(activity.start_at)).hours().toString()+ ' Hrs ' + moment.duration(new Date(activity.end_at) - new Date(activity.start_at)).minutes().toString() + ' Mins'

      @trip.total_flight_time = @get_total_flight_time(@trip)
      @trip.totalCost = @totalTripCost(@trip)
      @trip.taxBreakup = CustomerCostBreakUpsService.taxBreakUp(@trip)
      @trip.subTotal = CustomerCostBreakUpsService.subTotal(@trip)
      @trip.total_tax = @total_tax(@trip.taxBreakup)
  ).error(
    ->
      notify(
        massege: 'Error fetching trip'
        classes: ['alert-danger']
      )
  )

#  @set_sell_empty_leg = ->
#    $http.put('customers/set_sell_empty_leg.json',{trip_id: @trip.id, sell_empty_leg: @trip.sell_empty_leg}).success(
#      ->
#        notify(
#          message: 'successfully saved.'
#        )
#    ).error(
#      (data)=>
#        notify(
#          massege: data.errors[0]
#          classes: ['alert-danger']
#        )
#    )

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

  @include_commission = (cost)->
    cost + @jsg_commision/100 * cost

  @totalTripCost = (trip)->
    CustomerCostBreakUpsService.totalTripCost(trip)

  @total_tax = (taxes)->
    amount = 0.0
    for tax in taxes
      amount += tax.amount
    amount

  @balance_payable = (amount1, amount2)->
    amount1 - amount2

  @get_total_flight_time = (trip)->
    hours = 0
    minutes = 0
    flight_time_ = ''
    for activity in trip.activities
      unless activity.empty_leg
        hours += moment.duration(new Date(activity.end_at) - new Date(activity.start_at)).hours()
        minutes += moment.duration(new Date(activity.end_at) - new Date(activity.start_at)).minutes()
    hours += minutes/60 | 0
    minutes = minutes%60 | 0
    flight_time_ = (hours.toString()+' Hrs ' +minutes.toString()+ ' Mins')
    flight_time_



  @create_passenger_detail = ->
    return unless @validatedPassengerDetails()
    _passenger_details = []
    for passenger_detail in @passenger_details_
      _passenger_details.push({
        title: passenger_detail.title
        name: passenger_detail.name
#        email: passenger_detail.email
#        age: passenger_detail.age
        nationality: passenger_detail.nationality
#        contact: passenger_detail.contact
#        gender: passenger_detail.gender
        trip_id: @trip_id
      })

    $http.post('customers/create_passengers.json', { passenger_details: _passenger_details}).success(
      ->
        notify(
          message: 'Successfully saved.'
        )
        location.reload()
    ).error(
      (data)=>
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )

  @add_passenger_detail = ->
    @passenger_details_.push {}

  @remove_passenger_detail = (index)->
    if index > 0
      @passenger_details_.splice index, 1

  @validatedPassengerDetails = ->
    for passenger_detail in @passenger_details_
      unless passenger_detail.title
        notify
          message: 'Title cannot be blank.'
          classes: ['alert-danger']
        return false
      unless passenger_detail.name
        notify
          message: 'Name cannot be blank.'
          classes: ['alert-danger']
        return false
#      unless passenger_detail.age
#        notify
#          message: 'Age cannot be blank'
#          classes: ['alert-danger']
#        return false
      unless passenger_detail.nationality
        notify
          message: 'Nationality cannot be blank'
          classes: ['alert-danger']
        return false
#      unless passenger_detail.gender
#        notify
#          message: 'Gender cannot be blank.'
#          classes: ['alert-danger']
#        return false
#      unless passenger_detail.email
#        notify
#          message: 'Email cannot be blank.'
#          classes: ['alert-danger']
#        return false
#      unless passenger_detail.contact
#        notify
#          message: 'Contact cannot be blank.'
#          classes: ['alert-danger']
#        return false
    true

  @create_catering = ->
    $http.put('customers/catering',{ catering: @catering, trip_id: @trip_id }).success(
      ->
        notify(
          message: 'successfully saved.'
        )
        location.reload()
    ).error(
      (data)=>
        notify(
          massege: data.errors[0]
          classes: ['alert-danger']
        )

    )

  @aircraft_flight_cost_commission_in_percentage = (cost, percentage)->
    cost + (percentage/100 * cost)

  @aircraft_handling_cost_commission_in_percentage = (cost, percentage)->
    cost + (percentage/100 * cost)

  @aircraft_accomodation_cost_commission_in_percentage = (cost, percentage)->
    cost + (percentage/100 * cost)

  @can_add_passengers = ()->
    @trip.can_add_passenger = moment(new Date(this.trip.activities[0].start_at)).subtract(3, 'hour') > moment()

  return undefined

]