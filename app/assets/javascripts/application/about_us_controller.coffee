jetsetgo_app.controller 'AboutUsController', ['$http', 'notify', '$routeParams', ($http, notify, $routeParams)->


  @isFromMobile = false

  if $routeParams.isfrommobile == 'yes'
    @isFromMobile = true

  return undefined
]