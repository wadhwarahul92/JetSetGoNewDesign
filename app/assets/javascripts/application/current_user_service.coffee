jetsetgo_app.factory 'CurrentUserService', ['$http', '$q', 'notify', '$uibModal', ($http, $q, notify, $uibModal)->

  serviceInstance = {}

  serviceInstance.currentUser = null

  serviceInstance.signOut = ->
    if serviceInstance.currentUser
      $http.delete('/sign_out_.json').success(
        =>
          serviceInstance.currentUser = null
          notify
            message: 'Successfully signed out.'
      )
    else
      notify
        message: 'You are not signed in.'
        classes: ['alert-danger']

  serviceInstance.openSignInModal = ->
    if serviceInstance.currentUser
      notify
        message: 'You are already signed in.'
    else
      serviceInstance.modal.close() if serviceInstance.modal
      serviceInstance.modal = $uibModal.open(
        templateUrl: '/templates/sign_in_modal'
        size: 'sm'
        controller: 'SignInController'
        controllerAs: 'ctrl'
      )

  serviceInstance.getCurrentUser = ->
    if serviceInstance.currentUser
      deffered = $q.defer()
      deffered.resolve(serviceInstance.currentUser)
      return deffered.promise
    else
      promise = $http.get('/current_user.json')
      promise.success(
        (data)=>
          serviceInstance.setCurrentUser(data)
      ).error(
        ->
          notify
            message: 'You are not signed in.'
            classes: ['alert-danger']
          serviceInstance.currentUser = null
      )
      return promise

  serviceInstance.setCurrentUser = (currentUser)->
    notify
      message: "Welcome, #{currentUser.full_name}"
    serviceInstance.currentUser = currentUser
    serviceInstance.modal.close() if serviceInstance.modal

  serviceInstance.openSignUpModal = ->
    if serviceInstance.currentUser
      notify
        message: 'You are already signed in.'
        classes: ['alert-danger']
    else
      serviceInstance.modal.close() if serviceInstance.modal
      serviceInstance.modal = $uibModal.open(
        templateUrl: '/templates/sign_up_modal'
        size: 'sm'
        controller: 'SignUpController'
        controllerAs: 'ctrl'
      )

  serviceInstance.init = ->
    serviceInstance.getCurrentUser().then(
      (data)=>
        serviceInstance.setCurrentUser(data) if data and data.first_name
    )

  serviceInstance.init()


  return serviceInstance
]