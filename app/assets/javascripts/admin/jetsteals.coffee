jetsteals_form = angular.module 'jetsteals_form', []

jetsteals_form.controller 'FormController', [->

  @hr = '0'

  @min_ = '0'

  @flightDurationInMinutes = ->
    hr = parseInt(@hr)
    min = parseInt(@min_)
    parseInt((hr*60) + min)

  undefined
]

#if pathname = /admin/jetsteals/new, then bootstrap angular app to it
$(document).on('ready page:load', ->
  if document.getElementById('new_jetsteal')
    angular.bootstrap(document, ['jetsteals_form'])
)