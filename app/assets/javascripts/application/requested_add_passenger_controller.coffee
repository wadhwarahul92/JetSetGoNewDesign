jetsetgo_app.controller 'RequestedAddPassengerController', ['$http', 'notify', '$routeParams', '$location', ($http, notify, $routeParams, $location) ->

  @token = ''
  @trip_id = ''
  @trip = {}
  @passenger_details_ = [{}]
  @loading = true

  @token = $routeParams.token
  @trip_id = $routeParams.trip_id

#  $http.get('customers/get_shared_trip.json', {token: @token, trip_id: @trip_id })

#  $http.post('customers/set_share_passenger.json', {token: @token, trip_id: @trip_id, })


#  @past_journeys = {}
#
  $http.post('customers/get_shared_trip', {token: @token, trip_id: $routeParams.trip_id }).success(
    (data)=>
      @trip = data
      @loading = false
      if moment(Date.now()).isBefore(moment(new Date(@trip.activities[0].start_at)).subtract(3, 'hours'))
#        do nothing
      else
        $location.path('/')
  ).error(
    ->
      notify(
        message: 'Error fetching trip'
        classes: ['alert-danger']
      )
  )

  @count_flight_time = (activity)->
    moment.duration(new Date(activity.end_at) - new Date(activity.start_at)).hours().toString()+ ' Hrs ' + moment.duration(new Date(activity.end_at) - new Date(activity.start_at)).minutes().toString() + ' Mins'

  @create_catering = ->
    $http.put('customers/catering',{ catering: @trip.catering, trip_id: @trip_id, api_token: @token }).success(
      ->
        notify(
          message: 'successfully saved.'
        )
#        location.reload()
    ).error(
      (data)=>
        notify(
          massege: data.errors[0]
          classes: ['alert-danger']
        )

    )

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
      unless passenger_detail.nationality
        notify
          message: 'Nationality cannot be blank'
          classes: ['alert-danger']
        return false

    true

  @add_passenger_detail = ->
    @passenger_details_.push {}

  @remove_passenger_detail = (index)->
    if index > 0
      @passenger_details_.splice index, 1

  return undefined
]