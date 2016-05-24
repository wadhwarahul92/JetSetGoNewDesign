jetsetgo_app.controller "ProfileController", ['$http', 'notify', '$upload', 'CurrentUserService', '$scope', '$location', ($http, notify, $upload, CurrentUserService, $scope, $location) ->

  @currentUser = null

  $scope.$watch(
    =>
      CurrentUserService.currentUser
    ,
    =>
      @currentUser = CurrentUserService.currentUser
  )

#  setTimeout(
#    ->
#    unless @currentUser
#      debugger
#      $location.path("tmp_url")
#    3000
#  )

#  @checkFilters = ->
#
#    null

#  setTimeout(
#    ->
#      debugger
#      if  @currentUser
#        $location.path("/tmp_url")
#      else
##          do nothing
#  ,
#    3000
#  )
#  null

#  @checkFilters = ->
#    setTimeout(
#      ->
#        if $('.count_this').length == $('.count_this.ng-hide').length
#          $('#no_jetsteal').show()
#        else
#          $('#no_jetsteal').hide()
#    ,
#      100
#    )
#    null

#  if @currentUser == null
#    $location.path("/tmp_url")

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