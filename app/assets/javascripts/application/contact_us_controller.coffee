jetsetgo_app.controller 'ContactUsController', ['$http', 'notify', '$location', ($http, notify, $location)->

  @name = null
  @phone = null
  @email = null
  @message = null

  @create = ->
    $http.post('/create_contact.json', { name: @name, phone: @phone, email: @email, message: @message}).success(
      (data)=>
        @name = null
        @phone = null
        @email = null
        @message = null
        notify
          message: 'Successfully saved.'
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