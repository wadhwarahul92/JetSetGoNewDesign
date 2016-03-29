organisations_app.controller "SettingsController", ['$http', 'notify', ($http, notify) ->

  @terms_and_condition = null

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

  @get_t_and_c = ->
    $http.get("/organisations/operators/get_terms_and_condition.json").success(
      (data)=>
        @terms_and_condition = data.terms_and_condition
    ).error(
      (data)->
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )

  @update_t_and_c = ->
    $http.put("/organisations/operators/set_terms_and_condition.json", {t_and_c: @terms_and_condition}).success(
      ->
        notify(
          message: 'Terms and condition successfully saved.'
        )
    ).error(
      (data)->
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )

  return undefined
]