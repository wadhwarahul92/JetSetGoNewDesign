#= require ./notify

$.notify.defaults(
  globalPosition: 'top center'
  style: 'bootstrap'
)

class @JSGNotification
  #@type = [success, info, warn, error]
  constructor: (message, type)->
    @message = message
    @type = type

  show: ->
    @type ||= 'success'
    $.notify(@message, @type)