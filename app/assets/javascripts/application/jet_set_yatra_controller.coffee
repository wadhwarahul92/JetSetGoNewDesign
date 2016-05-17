jetsetgo_app.controller "JetSetYatraController", ['$http', 'notify', '$uibModal', 'CurrentUserService','AirportsService', ($http, notify, $uibModal, CurrentUserService, AirportsService) ->

  @activities = [{}]
  @currentUser = null
  @airports = []

  AirportsService.getAirports().then(
    =>
      @airports = AirportsService.airports
  )

  @yatra_enquiry = ->
    if CurrentUserService.currentUser
      $uibModal.open(
        size: 'md'
        templateUrl: '/templates/enquiry_form_modal'
        controller: 'JetSetYatraEnquiryController'
        controllerAs: 'ctrl'
        backdrop: true
      )
    else
      CurrentUserService.openSignInModal('md')

  return undefined
]