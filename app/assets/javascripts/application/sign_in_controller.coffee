jetsetgo_app.controller 'SignInController', ['$http', 'notify', 'CurrentUserService', ($http, notify, CurrentUserService)->

  @email = null

  @password = null

  @create = ->
    $http.post('/sign_in_.json', {email: @email, password: @password}).success(
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