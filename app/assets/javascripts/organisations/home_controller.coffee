organisations_app.controller 'HomeController', ['$http', 'notify', '$scope', '$compile', ($http, notify, $scope, $compile)->

  @events = []

  @refreshEvents = (view)->
    start = null
    end = null
    try
      start = view.start.toString()
      end = view.end.toString()
    url = '/organisations/trips/all_events.json'
    if start and end
      url = "#{url}?start_at=#{start}&end_at=#{end}"
    $http.get(url).success(
      (data)=>
        @events.splice 0, 1
        @events.push(data)
    ).error(
      ->
        notify
          message: 'Error fetching data'
          classes: ['alert-danger']
    )

  $scope.eventRender = (event, element, view)->
    element.attr({
      'uib-popover': event.popover
      'popover-trigger': 'mouseenter'
    })
    $compile(element)($scope)

  @calendarConfig = {
    calendar: {
      viewRender: (view, element)=>
        @refreshEvents(view)
      eventRender: $scope.eventRender
    }
  }

  return undefined
]