jetsetgo_app.controller 'MembershipCodeController', ['$http', 'notify', '$scope', '$location', ($http, $scope, $location, notify)->

  @validatedForm = ->
   if $('.txt_code').val() == 'greetings' || $('.txt_code').val() == 'Rahul'
     return true
   else
     alert('Please enter the valid code')
     return false

  @redirectToPlans = ->
    redirect = @validatedForm()
    if redirect
      window.location.replace("/membership_plan");

  return undefined
]