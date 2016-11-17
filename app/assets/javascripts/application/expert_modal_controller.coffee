jetsetgo_app.controller 'ExpertModalController', ['$scope', '$timeout', '$dialog', ($scope, $timeout, $dialog)->

  $timeout (->
    $dialog.dialog({}).open 'expert_modal.html.erb'
    return
  ), 3000
  return

  return undefined
]