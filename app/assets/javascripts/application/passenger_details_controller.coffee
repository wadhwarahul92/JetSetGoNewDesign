jetsetgo_app.controller 'PassengerDetailsController', ['$http', 'notify', '$routeParams', ($http, notify, $routeParams)->

  @passenger_details = []

  @passenger_details_ = [{}]

  @catering = ''

  @trip_id = $routeParams.id

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
      @catering =  @trip.catering
  ).error(
    ->
      notify(
        massege: 'Error fetching trip'
        classes: ['alert-danger']
      )
  )

  @create_passenger_detail = ->
#    return unless @validatedPassengerDetails()
    _passenger_details = []
    for passenger_detail in @passenger_details_
      _passenger_details.push({
        name: passenger_detail.name
        email: passenger_detail.email
        age: passenger_detail.age
        contact: passenger_detail.contact
        gender: passenger_detail.gender
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
    for passenger_detail in @passenger_details
      unless passenger_detail.name
        notify
          message: 'Name cannot be blank.'
          classes: ['alert-danger']
        return false
      unless passenger_detail.age
        notify
          message: 'Age cannot be blank'
          classes: ['alert-danger']
        return false
      unless passenger_detail.gender
        notify
          message: 'Gender cannot be blank.'
          classes: ['alert-danger']
        return false
      unless passenger_detail.email
        notify
          message: 'Email cannot be blank.'
          classes: ['alert-danger']
        return false
      unless passenger_detail.contact
        notify
          message: 'Contact cannot be blank.'
          classes: ['alert-danger']
        return false
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

  return undefined
]