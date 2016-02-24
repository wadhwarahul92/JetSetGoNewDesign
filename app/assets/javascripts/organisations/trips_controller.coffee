organisations_app.controller 'TripsController', ['$http', 'notify', ($http, notify)->

  @events = []

  @calendarView = 'month'

  @activity = null

  scope = this

  @eventClicked = (event)->
    $http.get("/organisations/trips/#{event.id}.json").success(
      (data)=>
        if data
          scope.activity = data
    ).error(
      ->
        notify
          message: 'Error fetching activity, 1x0098'
          classes: ['alert-danger']
    )

  @calendarConfig = {
    calendar: {
      eventClick: @eventClicked
      viewRender: (view, element)=>
        @refreshEvents(view)
    }
  }

  @deleteActivity = ->
    if @activity
      bootbox.confirm('Are your sure?', (result)=>
        if result
          $http.delete("/organisations/trips/#{@activity.id}").success(
            =>
              Turbolinks.visit('/organisations/trips')
          )
      )
    null

  @refreshEvents = (view)->
    start = null
    end = null
    try
      start = view.start.toString()
      end = view.end.toString()
    url = '/organisations/trips.json'
    if start and end
      url = "#{url}?start_at=#{start}&end_at=#{end}"
    $http.get(url).success(
      (data)=>
        @events.splice 0, 1
        @events.push(data)
    ).error(
      ->
        notify
          message: 'Error fetching trips'
          classes: ['alert-danger']
    )

  return undefined
]