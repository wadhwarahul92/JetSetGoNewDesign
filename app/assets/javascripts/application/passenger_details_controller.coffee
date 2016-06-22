jetsetgo_app.controller 'PassengerDetailsController', ['$http', 'notify', ($http, notify)->

  @passenger_details = []

  @passenger_details_ = [{}]

  @trip_id = 311

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

  @create_passenger_detail = ->
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

  return undefined
]