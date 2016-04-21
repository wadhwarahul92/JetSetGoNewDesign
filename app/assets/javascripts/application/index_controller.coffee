jetsetgo_app.controller 'IndexController', ['$http', 'notify', 'AirportsService', '$scope', '$location', ($http, notify, AirportsService, $scope, $location)->

  @activities = [{}]

  @options = {
    barColor:'#2C3E50'
    scaleColor:false
    lineWidth:10
    lineCap:'circle'
    size: 400
    animate: 5000
    onStep: (from, to, current)->
      span = $(this.el).find('.percent')
      span.html("#{parseInt(current)}%")
  }

  $scope.$watch(
    =>
      @activities
    ,
    =>
      @formatActivities()
    ,
    true
  )

  @airports = []

  @onSetTime = (newDate, oldDate, index)->
    if index + 1 == @activities.length
      #do nothing
    else
      alert 'cannot change date'
      @activities[index].start_at  = oldDate

  @beforeRenderDate = (view, dates, leftDate, upDate, rightDate, index)->
    activeDate = null
    if index > 0
      previous_activity = @activities[index-1]
      time = previous_activity.start_at
      if time
        activeDate = moment(time)
        for date in dates
          if date.localDateValue() <= activeDate.valueOf()
            date.selectable = false
    else
      activeDate = moment(new Date())
      for _date in dates
        if _date.localDateValue() <= activeDate.valueOf()
          _date.selectable = false


  @formatActivities = ->
    previous = null
    for activity in @activities
      if previous
        activity.departure_airport = previous.arrival_airport
      previous = activity

  AirportsService.getAirports().then(
    =>
      @airports = AirportsService.airports
  )

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, h:mm:ss A')
    if data and data == 'Invalid date'
      return 'Click to choose time'
    else
      return data

  @addActivity = ->
    return unless @validatedActivities()
    @activities.push {}

  @removeActivity = (index)->
    if index > 0
      @activities.splice index, 1

  @validatedActivities = ->
    for activity in @activities
      unless activity.departure_airport
        notify
          message: 'Departure cannot be blank.'
          classes: ['alert-danger']
        return false
      unless activity.arrival_airport
        notify
          message: 'Arrival cannot be blank'
          classes: ['alert-danger']
        return false
      if activity.departure_airport == activity.arrival_airport
        notify
          message: 'Departure cannot be same as Arrival.'
          classes: ['alert-danger']
        return false
      unless activity.start_at
        notify
          message: 'Time cannot be blank.'
          classes: ['alert-danger']
        return false
      unless activity.pax
        notify
          message: 'Pax cannot be blank.'
          classes: ['alert-danger']
        return false
    true


  @create = ->
    return unless @validatedActivities()
    _activities = []
    for activity in @activities
      _activities.push({
        departure_airport_id: activity.departure_airport.id
        arrival_airport_id: activity.arrival_airport.id
        start_at: activity.start_at
        pax: activity.pax
      })
    $http.post('/searches.json', { activities: _activities }).success(
      (data)->
        $location.path("/searches/#{data.search_id}")
    ).error(
      (data)->
        error = 'Something went wrong.'
        try
          error = data.errors[0]
        notify
          message: error
          classes: ['alert-danger']
    )

  return undefined
]