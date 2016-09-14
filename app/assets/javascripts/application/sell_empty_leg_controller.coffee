jetsetgo_app.controller 'SellEmptyLegController', ['$http', 'notify', 'CurrentUserService', '$scope', '$location', 'CustomerCostBreakUpsService', ($http, notify, CurrentUserService, $scope, $location, CustomerCostBreakUpsService)->

  @currentUser = null

  @confirmed_trips = {}

  @loading = true

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
        location.replace('tmp_url')
  ,
    1500
  )

  $http.get('customers/get_booked_jets.json').success(
    (data)=>
      @confirmed_trips = data
      @loading = false
  ).error(
    ->
      notify(
        message: 'Error fetching booked jets'
        classes: ['alert-danger']
      )
  )

  @starting_date = (trip)->
    for activity in trip.activities
#      return moment(activity.start_at).format('Do MMMM YYYY');
      return moment(new Date(activity.start_at)).format('Do MMMM YYYY')

  @date_format = (time)->
#    moment(time).format('Do MMMM YYYY, HH:MM A');
    moment(new Date(time)).format('Do MMMM YYYY, HH:MM A')

  @sell_empty_leg = (activity, trip)->
    $http.put('customers/activity_sell_empty_leg.json',{trip_id: trip.id, activity_id: activity.id, in_sale: activity.in_sale, minimum_sale_price: activity.minimum_sale_price, maximum_sale_price: activity.maximum_sale_price, sell_button_clicked: true}).success(
      ->
        notify(
          message: 'successfully saved.'
        )
        activity.sell_button_clicked = true
    ).error(
      (data)=>
        notify(
          massege: data.errors[0]
          classes: ['alert-danger']
        )
    )

#  @uncheck = (activity, bool)->
#    debugger

  @doMediaQuery = (activity)->
    activity.more_detail_active = true
    w = angular.element(window).width()
    if w < 768
      activity.more_detail_active = false

  @flight_time = (start_at, end_at)->
    flight_time = ''
    duration = moment.duration(moment(new Date(end_at)).diff(moment(new Date(start_at))))

    flight_time = duration.hours()+' Hrs '+duration.minutes()+' Mins '
    flight_time

  @editable = (activity)->
    if moment(Date.now()).isBefore(moment(new Date(activity.start_at)).subtract(3, 'hours'))
      activity.is_editable = true
    else
      activity.is_editable = false

  return undefined
]