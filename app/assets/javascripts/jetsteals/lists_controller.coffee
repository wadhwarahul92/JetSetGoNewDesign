jetsteals_list = angular.module 'jetsteals_list', []

jetsteals_list.controller 'JetstealsListController', ['$http', ($http)->

  @jetsteals = [{id: 1}]

  $http.get('/jetsteals/list.json').success(
    (data)=>
      if data
        @jetsteals = data
      else
        console.error('Could not fetch jetsteals')
  ).error(
    ->
      console.error('Could not fetch jetsteals')
  )

  return undefined
]