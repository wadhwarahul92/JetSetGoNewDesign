organisations_app.controller "ProfileController", ['$http', 'notify', ($http, notify) ->

  url_split = location.pathname.match(/\/organisations\/operators\/(\d+)\/profile/)
  id = null
  id = url_split[1] if url_split
  if id
    $http.get("/organisations/operators/#{id}/profile.json").success(
      (data)=>
       @operator = data
    ).error(
      ->
        notify(
          message: 'Error fetching Operator'
          classes: ['alert-danger']
        )
    )


  return undefined
]