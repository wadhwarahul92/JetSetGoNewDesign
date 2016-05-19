jetsetgo_app.controller "JetSetWedController", ['$http', 'notify', '$uibModal', ($http, notify, $uibModal) ->

  @wed_enquiry = ->
    $uibModal.open(
      size: 'md'
      templateUrl: '/templates/enquiry_form_modal'
      controller: 'JetSetWedEnquiryController'
      controllerAs: 'ctrl'
      backdrop: true
    )

  return undefined
]