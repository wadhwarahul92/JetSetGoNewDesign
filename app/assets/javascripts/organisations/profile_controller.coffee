organisations_app.controller "ProfileController", ['$http', 'notify', '$upload', ($http, notify, $upload) ->

  @operator = {}

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

  @uploadOperatorImage = (files, operator)->
    return unless files[0]
    $upload.upload(
      file: files[0]
      url: "/organisations/operators/#{operator.id}/update_image.json"
      method: "put"
    ).success(
      (data)=>
        @operator.image = data.image_url
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

  return undefined
]