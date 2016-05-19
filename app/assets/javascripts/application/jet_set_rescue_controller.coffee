jetsetgo_app.controller "JetSetRescueController", ['$http', 'notify', '$uibModal', ($http, notify, $uibModal) ->

  @rescue_enquiry = ->
    $uibModal.open(
      size: 'md'
      templateUrl: '/templates/enquiry_form_modal'
      controller: 'JetSetRescueEnquiryController'
      controllerAs: 'ctrl'
      backdrop: true
    )

  return undefined
]