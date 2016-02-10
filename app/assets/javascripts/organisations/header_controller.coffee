organisations_app.controller 'HeaderController', [->

  @organisationLinkState = false

  @organisationLinkToggled = (open)->
    @organisationLinkState = open

  return undefined
]