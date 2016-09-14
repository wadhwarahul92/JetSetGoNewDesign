jetsetgo_app.controller 'TmpSendSmsController', ['$http', '$location', 'notify', ($http, $location, notify)->

  @message = ''

  @phone_numbers = []

  @sendSMS = ->
    $http.post('/tmp_message_send', text: @message, phone: @phone_numbers).success(
      =>
        notify(
          message: 'Successfully saved.'
        )
    ).error(
      =>
        notify(
          message: 'Something went wrong'
          classes: ['alert-danger']
        )
    )

  return undefined
]