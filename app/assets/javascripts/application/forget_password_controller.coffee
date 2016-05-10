jetsetgo_app.controller 'ForgetPasswordController', ['$http','notify', '$timeout', ($http, notify, $timeout)->

  $timeout (->
    angular.element('.closs-btn').triggerHandler 'click'
    return
  ), 0

  @email = null

  @create = ->
    $http.post('/forgot_password_.json', {email: @email}).success(
      =>
        @email = null
        notify(
          message: 'Email sent. Check your inbox.'
        )
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