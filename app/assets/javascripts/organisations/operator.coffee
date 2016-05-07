organisations_app.controller "OperatorController", ['$http', 'notify', '$scope', ($http, notify, $scope) ->

  @roles = ['admin', 'operator']

#  @designations = ['ceo', 'coo', 'editor', 'finance', 'manager']

  @designations = [{name:'Ceo', value:'dark'},
                   {name:'Coo', value:'coo'},
                   {name:'Editor', value:'editor'},
                   {name:'Finance' value:'finance'},
                   {name:'Manager', value:'manager'}]

  @operator = {}

  @operatorRoleMap = {}

  @create = ->
    $http.post("/organisations/operators.json", @operator).success(
      ->
        notify(
          message: 'New operater created.'
        )
        Turbolinks.visit('/organisations/settings')
    ).error(
      (data)->
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )
  @update = ->
    $http.put("/organisations/operators/#{@operator.id}.json", @operator).success(
      ->
        Turbolinks.visit('/organisations/settings')
    ).error(
      (data)->
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )

  $scope.$watchCollection(
    =>
      @operatorRoleMap
    ,
    =>
      if @operator
        @operator.roles = []
        angular.forEach(@operatorRoleMap, (value, key)=>
          if value
            @operator.roles.push(key)
        )
  )

  url_split = location.pathname.match(/\/organisations\/operators\/(\d+)\/edit/)
  id = null
  id = url_split[1] if url_split
  if id
    $http.get("/organisations/operators/#{id}/edit.json").success(
      (data)=>
        @operator = data
        if @operator.roles
          for role in @operator.roles
            @operatorRoleMap[role] = true
    ).error(
      ->
        notify(
          message: 'Error fetching aircraft types'
          classes: ['alert-danger']
        )
    )

  url_split = location.pathname.match(/\/organisations\/operators\/(\d+)\/edit_profile/)
  id = null
  id = url_split[1] if url_split
  if id
    $http.get("/organisations/operators/#{id}/profile.json").success(
      (data)=>
        @operator = data
    ).error(
      ->
        notify(
          message: 'Error fetching aircraft types'
          classes: ['alert-danger']
        )
    )

  @update_profile = ->
    $http.put("/organisations/operators/#{@operator.id}/update_profile.json", @operator).success(
      =>
        Turbolinks.visit("/organisations/operators/#{@operator.id}/profile")
    ).error(
      (data)->
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )

  return undefined
]