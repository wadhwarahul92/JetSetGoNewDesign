organisations_app.controller 'SignInController', ['$http', 'notify', ($http, notify)->

  @user = {}

  @create = ->
    $http.post('/organisations/sign_in.json', @user).success(
      ->
        notify(
          message: 'Successfully signed in'
        )
        Turbolinks.visit('/organisations')
    ).error(
      (data)->
        error = 'Something went wrong.'
        try
          error = data.errors[0]
        notify(
          message: error
          classes: ['alert-danger']
        )
    )

  return undefined
]