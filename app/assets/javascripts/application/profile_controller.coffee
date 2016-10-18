jetsetgo_app.controller "ProfileController", ['$http', 'notify', '$upload', 'CurrentUserService', '$scope', '$location', ($http, notify, $upload, CurrentUserService, $scope, $location) ->

  @currentUser = null

  @upd_profile = false

  @btn_show = false

  @active_pwd = false

  @password = ''

#  @enquired_jets = {}
#
#  @booked_jets = {}
#
#  @quotes = {}
#
#  @trips = {}

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
        location.replace('/')
    ,
    1500
  )

  $http.get('/current_user.json').success(
    (data)=>
      scope.currentUser = data
  ).error(
    ->
      notify(
        message: 'not logged in'
        classes: ['alert-danger']
      )
  )
#
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
#
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
#
#
#  $http.get('/trips/get_quotes.json').success(
#    (data)=>
#      @quotes = data
#  ).error(
#    ->
#      notify
#        message: 'Error fetching quotes'
#        classes: ['alert-danger']
#  )

  @uploadUserImage = (files, operator)->
    return unless files[0]
    $upload.upload(
      file: files[0]
      url: 'customers/update_image.json'
      method: "put"
    ).success(
      (data)=>
        @currentUser.image = data.image_url
    ).error(
      (data)->
        error = 'Something went wrong'
        try
          error = data.errors[0]
        notify(
          message: error
          classes: ['alert-danger']
        )
    )
    return undefined

  @update_profile = ->
    $http.put('customers/update_profile.json', @currentUser).success(
      =>
        notify(
          message: 'Successfully saved.'
        )
        @btn_show = false
    ).error(
      (data)=>
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
        @upd_profile = true
        @btn_show = true
    )

  @change_password = ->
    $http.put('customers/change_password_', { password: @password }).success(
      =>
        notify(
          message: 'Successfully saved. Please login again.'
        )
        location.replace('/')
    ).error(
      (data)=>
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )

  @onSetTime = (newDate, oldDate)->
    #do nothing

  @beforeRenderDate = (view, dates, leftDate, upDate, rightDate)->
    activeDate = null
    activeDate = moment(new Date())
    if @currentUser.dob != null
      activeDate = moment(new Date(@currentUser.dob))

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM, YYYY')
    if data and data == 'Invalid date'
      return 'Date of birth'
    else
      return data

#  @count_empty_legs = (trips)->
#    count = 0
#    for trip in trips
#      for activity in trip.activities
#        if activity.empty_leg == true
#          count = count+1
#    return count

  return undefined
]