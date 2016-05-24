jetsetgo_app.controller "ProfileController", ['$http', 'notify', '$upload', 'CurrentUserService', '$scope', '$location', ($http, notify, $upload, CurrentUserService, $scope, $location) ->

  @currentUser = null

  @upd_profile = false

  @btn_show = false

  $scope.$watch(
    =>
      CurrentUserService.currentUser
    ,
    =>
      @currentUser = CurrentUserService.currentUser
  )

  scope = this

  setTimeout(
    ->
      unless scope.currentUser
        location.replace('tmp_url')
    ,
    1500
  )

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

  @update_profile = ->
    $http.put("/customers/update_profile.json", @currentUser).success(
      =>
        notify(
          message: 'Successfully saved.'
        )
        @btn_show = false
    ).error(
      (data)=>
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
        @upd_profile = true
        @btn_show = true
    )

  return undefined
]