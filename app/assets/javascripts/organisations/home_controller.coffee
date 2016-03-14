organisations_app.controller 'HomeController', ['$http', 'notify', '$scope', '$compile', '$uibModal', ($http, notify, $scope, $compile, $uibModal)->

  @events = []

  @activity = null

  scope = this

  $scope.eventClicked = (event, jsEvent, view)->
    id = event.id
    record_id = null
    if id
      if id.match(/activity-(\d+)/)
        record_id = id.match(/activity-(\d+)/)[1]
        $http.get("/organisations/activities/#{record_id}.json?format_as=event").success(
          (data)=>
            scope.activity = data
        ).error(
          ->
            notify
              message: 'Error fetching activity. 1x1009'
              classes: ['alert-danger']
        )
      else if id.match(/aircraft_unavailability-(\d+)/)
        record_id = id.match(/aircraft_unavailability-(\d+)/)[1]
        $http.get("/organisations/aircraft_unavailabilities/#{record_id}.json?format_as=event").success(
          (data)=>
            scope.activity = data
        ).error(
          ->
            notify
              message: 'Error fetch aircraft unavilability. 1x1009'
              classes: ['alert-danger']
        )
      else if id.match(/enquiry-(\d+)/)
        record_id = id.match(/enquiry-(\d+)/)[1]
        $uibModal.open(
          size: 'lg'
          templateUrl: '/templates/enquiry'
          controller: 'EnquiryController'
          controllerAs: 'ctrl'
          backdrop: false
          resolve: {
            enquiry: ->
              $http.get("/organisations/trips/#{record_id}/get_enquiry.json").then(
                (response)->
                  response.data
              )
          }
        )
      else if id.match(/quote-(\d+)/)
        record_id = id.match(/quote-(\d+)/)[1]
        $uibModal.open(
          size: 'lg'
          templateUrl: '/organisations/templates/quote'
          controller: 'QuoteController'
          controllerAs: 'ctrl'
          backdrop: false
          resolve: {
            quote: ->
              $http.get("/organisations/trips/#{record_id}/get_quote.json").then(
                (response)->
                  response.data
              )
          }
        )

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
      'popover-append-to-body': true
      'popover-title': event.popover_title
    })
    $compile(element)($scope)

  @calendarConfig = {
    calendar: {
      header: {
#        center: 'month,agendaWeek'
      }
      viewRender: (view, element)=>
        @refreshEvents(view)
      eventRender: $scope.eventRender
      eventClick: $scope.eventClicked
    }
  }

  @newTrip = ->
    $uibModal.open(
      size: 'lg'
      templateUrl: '/organisations/trips/new'
      controller: 'NewTripController'
      controllerAs: 'ctrl'
      backdrop: false
    )
  @newUnavailability = ->
    $uibModal.open(
      size: 'lg'
      templateUrl: '/organisations/aircraft_unavailabilities/new'
      controller: 'NewUnavailabilityController'
      controllerAs: 'ctrl'
      backdrop: false
    )

  return undefined
]