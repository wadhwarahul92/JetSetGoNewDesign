jetsetgo_app.controller 'SearchController', ['$http', 'notify', '$routeParams', ($http, notify, $routeParams)->

  @results = []

  $http.get("/searches/#{$routeParams.id}.json").success(
    (data)=>
      @results = data
  ).error(
    (data)->
      error = 'Something went wrong.'
      try
        error = data.errors[0]
      notify
        message: error
        classes: ['alert-danger']
  )

  return undefined
]