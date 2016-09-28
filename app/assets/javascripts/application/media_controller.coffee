jetsetgo_app.controller 'MediaController', ['$http', 'notify', ($http, notify)->


  @media = []


  $http.get('/media_contents.json').success(
    (data)=>
      @media = data
    ).error(
    ->
      alert 'error fetching media, try again later'
  )

  return undefined
]