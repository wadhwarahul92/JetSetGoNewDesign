organisations_app.controller 'HeaderController', [->

  @organisationLinkState = false

  @organisationLinkToggled = (open)->
    @organisationLinkState = open
  
#  @schedule_active = "active_schedule"
#  @aircraft_active = "active_aircraft"
#  @forum_active = "active_forum"
#  @unavailibility_active = "active_unavailibility"
#  @trips_active = "active_trips"
#  @schedule_active = ""
#  @aircraft_active = ""
#  @forum_active = ""
#  @unavailibility_active = ""
#  @trips_active = ""

#  url = location.pathname.match("/organisations/forum_topics")
#  url_icon = null
#  url_icon = url[0] if url
#  if url_icon && url_icon == '/organisations/forum_topics'
#    @schedule_active = "active_schedule"
#  else
#    @schedule_active = ""

  return undefined
]