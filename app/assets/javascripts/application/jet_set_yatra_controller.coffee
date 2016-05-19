jetsetgo_app.controller "JetSetYatraController", ['$http', 'notify', '$uibModal', ($http, notify, $uibModal) ->

  @yatra_enquiry = ->
    $uibModal.open(
      size: 'md'
      templateUrl: '/templates/enquiry_form_modal'
      controller: 'JetSetYatraEnquiryController'
      controllerAs: 'ctrl'
      backdrop: true
    )

  return undefined
]