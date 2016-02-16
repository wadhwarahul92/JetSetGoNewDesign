organisations_app.controller 'OrganisationAdminController', ['$http', 'notify', ($http, notify)->

  @user = {}

  url_split = location.pathname.match(/\/organisations\/(\d+)\/operators\/admin/)

  if url_split
    id = url_split[1]
    if id
      @id = id
    else
      notify(
        message: 'Error: Could not fetch orgainsation.'
        classes: ['alert-danger']
      )

  @create = ->
    $http.post("/organisations/#{@id}/operators/create_admin", @user).success(
      ->
        notify(
          message: 'Successfully signed in'
        )
        Turbolinks.visit('/organisations')
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