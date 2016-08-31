organisations_app.controller 'ForgotPasswordController', ['$http', 'notify', '$location', ($http, notify, $location)->

  @email = null

  @create = ->
    $http.post('/organisations/operators/forgot_password_.json', {email: @email}).success(
      =>
        @email = null
        notify(
          message: 'Email sent. Check your inbox.'
        )
        location.replace('/')
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
]