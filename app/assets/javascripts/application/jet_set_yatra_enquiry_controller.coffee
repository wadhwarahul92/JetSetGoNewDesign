jetsetgo_app.controller 'JetSetYatraEnquiryController', ['$http', 'notify', 'AirportsService', '$scope', '$location', '$routeParams', 'CurrentUserService','$timeout', ($http, notify, AirportsService, $scope, $location, $routeParams, CurrentUserService, $timeout)->

  @package = ['Chardham Yatra (4 Nights)', 'Dodham Yatra (2 Nights)', '1 Night Chardham Yatra', 'Hemkundsahib Yatra', 'Kedarnath Yatra', 'Muktinath Darshan - Nepal', 'Kailash And Mansarovar Yatra - Nepal']
  @enquiry = {}
  @currentUser = null

#  if $routeParams.search_id
#    $http.get("/searches/#{$routeParams.search_id}/get_for_index.json").success(
#      (data)=>
#        @activities = data
#        for activity in @activities
#          activity.start_at = new Date(activity.start_at)
#    )

  @signIn = ->
    CurrentUserService.openSignInModal('md')

  @signOut = ->
    CurrentUserService.signOut()

#  @options = {
#    barColor:'rgb(27,143,188)'
#    scaleColor:false
#    lineWidth:10
#    lineCap:'circle'
#    size: 220
#    animate: 5000
#    onStep: (from, to, current)->
#      span = $(this.el).find('.percent')
#      span.html("#{parseInt(current)}%")
#  }

#  $scope.$watch(
#    =>
#      @activities
#  ,
#    =>
#      @formatActivities()
#  ,
#    true
#  )

  $scope.$watch(
    =>
      CurrentUserService.currentUser
  ,
    =>
      @currentUser = CurrentUserService.currentUser
  )
#
#  @airports = []
#
#  @jetsteals = []

#  @onSetTime = (newDate, oldDate, index)->
#    if index + 1 == @activities.length
##do nothing
#    else
#      alert 'cannot change date'
#      @activities[index].start_at  = oldDate

  @beforeRenderDate = (view, dates, leftDate, upDate, rightDate, index)->
    activeDate = null
    if index > 0
      previous_activity = @activities[index-1]
      time = previous_activity.start_at
      previous_date = time.getDate()
      previous_month = time.getMonth()
      if view == 'day'
        for __date in dates
          if parseInt(__date.display) < previous_date and (new Date(__date.localDateValue())).getMonth() == previous_month
            __date.selectable = false
      else
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


#  @formatActivities = ->
#    previous = null
#    for activity in @activities
#      if previous
#        activity.departure_airport = previous.arrival_airport
#      previous = activity
#
#  AirportsService.getAirports().then(
#    =>
#      @airports = AirportsService.airports
#  )
#
#  # fetching jetsteals
#  arr = []
#  $http.get('/jetsteals/get_list.json').success(
#    (data)=>
#      $.each(data, (i, v)=>
#        if !v.sold_out && arr.length < 2
#          arr.push(v)
#          @jetsteals = arr
#      )
#  ).error(
#    ->
#      alert 'error fetching jetsteals, try again later'
#  )

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, hh:mm A')
    if data and data == 'Invalid date'
      return 'Click to choose time'
    else
      return data

#  @formatDate = (time)->
#    data = null
#    try
#      data = moment(new Date("#{time}")).format('Do MMM YYYY')
#    if data and data == 'Invalid date'
#      return 'Click to choose time'
#    else
#      return data

#  @addActivity = ->
#    return unless @validatedActivities()
#    @activities.push {}
#
#  @addRoundTrip = ->
#    return unless @validatedActivities()
#    @activities.push {arrival_airport: @activities[0].departure_airport}
#
#  @removeActivity = (index)->
#    if index > 0
#      @activities.splice index, 1

  @validatedActivities = ->
    unless @enquiry.name
      notify
        message: 'Name cannot be blank.'
        classes: ['alert-danger']
      return false
    unless @enquiry.email
      notify
        message: 'Email cannot be blank'
        classes: ['alert-danger']
      return false
    unless @enquiry.mobile_number
      notify
        message: 'Mobile number cannot be blank.'
        classes: ['alert-danger']
      return false
    unless @enquiry.date_of_travel
      notify
        message: 'Date of travel cannot be blank.'
        classes: ['alert-danger']
      return false
    unless @enquiry.package
      notify
        message: 'Package cannot be blank.'
        classes: ['alert-danger']
      return false
    true


  @create = ->
    return unless @validatedActivities()
    @enquiry = {
      name: @enquiry.name
      email: @enquiry.email
      mobile_number: @enquiry.mobile_number
      date_of_travel: @enquiry.date_of_travel
      package: @enquiry.package
    }

    $http.post('yatra_enquiries.json', enquiry: @enquiry).success(
      (data)->
        @enquiry = {}
        notify
          message: "Successfully saved. We'll contact you soon."
        $scope.$close()
    ).error(
      (data)->
        error = 'Something went wrong'
        try
          error = data.errors[0]
        notify
          message: error
          classes: ['alert-danger']
    )

  return undefined
]