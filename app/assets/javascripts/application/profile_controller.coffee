jetsetgo_app.controller "ProfileController", ['$http','$location', 'notify', '$upload', 'CurrentUserService', '$scope', ($http, $location, notify, $upload, CurrentUserService, $scope) ->

  @currentUser = null

  $scope.$watch(
    =>
      CurrentUserService.currentUser
    ,
    =>
      @currentUser = CurrentUserService.currentUser
  )

  if @currentUser == null
    $location.path("/tmp_url");
  else
#    do nothing

  @uploadUserImage = (files, operator)->
    return unless files[0]
    $upload.upload(
      file: files[0]
      url: "/customers/update_image.json"
      method: "put"
    ).success(
      (data)=>
        @currentUser.image = data.image_url
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