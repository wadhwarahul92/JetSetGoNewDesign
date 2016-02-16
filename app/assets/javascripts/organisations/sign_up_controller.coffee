organisations_app.controller 'SignUpController', ['$http', 'notify', ($http, notify)->

  @organisation = {}

  @create = ->
    $http.post('/organisations/sign_up.json', @organisation).success(
      (data)->
        notify(
          message: 'Organisation successfully created.'
        )
        if data.organisation.id
          Turbolinks.visit("/organisations/#{data.organisation.id}/operators/admin")
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