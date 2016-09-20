jetsetgo_app.controller 'SignUpController', ['$http', 'notify', 'CurrentUserService', ($http, notify, CurrentUserService)->

  @user = {}

  @openSignInModal = ->
    CurrentUserService.openSignInModal('md')

  @validatedActivities = ->
    unless @user.first_name
      notify
        message: 'Name cannot be blank.'
        classes: ['alert-danger']
      return false
    unless @user.phone
      notify
        message: 'Phone cannot be blank'
        classes: ['alert-danger']
      return false
    unless @user.phone.length == 10
      notify
        message: 'Invalid phone number.'
        classes: ['alert-danger']
      return false
    unless @user.email
      notify
        message: 'Email cannot be blank.'
        classes: ['alert-danger']
      return false
    unless @user.password
      notify
        message: 'Password cannot be blank.'
        classes: ['alert-danger']
      return false
    unless @user.password.length > 7
      notify
        message: 'Password length cannot be less than 8.'
        classes: ['alert-danger']
      return false
    true

  @create = ->
    return unless @validatedActivities()

    $http.post('/sign_up_.json', @user).success(
      (data)=>
        CurrentUserService.setCurrentUser(data)
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