organisations_app.controller "OperatorController", ['$http', 'notify', ($http, notify) ->

  @roles = ['admin', 'operator']

  @update = ->
    $http.put("/organisations/operators/#{@operator.id}.json", @operator).success(
      ->
        location.replace('/organisations/settings')
    ).error(
      (data)->
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )

  url_split = location.pathname.match(/\/organisations\/operators\/(\d+)\/edit/)
  id = null
  id = url_split[1] if url_split
  if id
    $http.get("/organisations/operators/#{id}/edit.json").success(
      (data)=>
        @operator = data
    ).error(
      ->
        notify(
          message: 'Error fetching aircraft types'
          classes: ['alert-danger']
        )
    )

  return undefined
]