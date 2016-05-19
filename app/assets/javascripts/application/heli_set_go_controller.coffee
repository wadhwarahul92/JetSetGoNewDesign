jetsetgo_app.controller "HeliSetGoController", ['$http', 'notify', '$uibModal', ($http, notify, $uibModal) ->

  @heli_set_go_enquiry = ->
    $uibModal.open(
      size: 'md'
      templateUrl: '/templates/enquiry_form_modal'
      controller: 'HeliSetGoEnquiryController'
      controllerAs: 'ctrl'
      backdrop: true
    )

  return undefined
]