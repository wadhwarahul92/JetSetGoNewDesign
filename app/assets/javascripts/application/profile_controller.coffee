jetsetgo_app.controller "ProfileController", ['$http', 'notify', '$upload', 'CurrentUserService', '$scope', ($http, notify, $upload, CurrentUserService, $scope) ->

  @currentUser = null

  $scope.$watch(
    =>
      CurrentUserService.currentUser
    ,
    =>
      @currentUser = CurrentUserService.currentUser
  )

  @uploadUserImage = (files, operator)->
    return unless files[0]
    $upload.upload(
      file: files[0]
      url: "/template/#{currentUser.id}/update_image.json"
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