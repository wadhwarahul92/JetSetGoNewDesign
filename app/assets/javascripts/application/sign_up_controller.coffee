jetsetgo_app.controller 'SignUpController', ['$http', 'notify', 'CurrentUserService', ($http, notify, CurrentUserService)->

  @user = {}

  @openSignInModal = ->
    CurrentUserService.openSignInModal()

  @create = ->
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