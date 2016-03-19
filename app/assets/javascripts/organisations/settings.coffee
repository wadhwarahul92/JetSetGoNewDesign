organisations_app.controller "SettingsController", ['$http', 'notify', ($http, notify) ->

  @toggleOperator = (id)->
    $http.put("/organisations/operators/#{id}/toggle.json").success(
      ->
        Turbolinks.visit('/organisations/settings')
    ).error(
      (data)->
        error = 'Somehting went wrong.'
        try
          error = data.errors[0]
        notify
          message: error
          classes: ['alert-danger']
    )

  return undefined
]