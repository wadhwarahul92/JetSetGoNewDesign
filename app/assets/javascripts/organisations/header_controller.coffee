organisations_app.controller 'HeaderController', [->

  @organisationLinkState = false

  @organisationLinkToggled = (open)->
    @organisationLinkState = open

  @schedule_active = ""
  @aircraft_active = ""
  @forum_active = ""
  @unavailibility_active = ""
  @trips_active = ""

  if location.pathname == '/organisations'
    @schedule_active = "active_schedule"
  else
    url = location.pathname.match("/organisations/aircrafts")
    url_icon = null
    url_icon = url[0] if url
    if url_icon && url_icon == '/organisations/aircrafts'
      @aircraft_active = "active_aircraft"
    else
      @aircraft_active = ""


    url = location.pathname.match("/organisations/forum_topics")
    url_icon = null
    url_icon = url[0] if url
    if url_icon && url_icon == '/organisations/forum_topics'
      @forum_active = "active_forum"
    else
      @forum_active = ""


    url = location.pathname.match("/organisations/aircraft_unavailabilities")
    url_icon = null
    url_icon = url[0] if url
    if url_icon && url_icon == '/organisations/aircraft_unavailabilities'
      @unavailibility_active = "active_unavailibility"
    else
      @unavailibility_active = ""


    url = location.pathname.match("/organisations/trips")
    url_icon = null
    url_icon = url[0] if url
    if url_icon && url_icon == '/organisations/trips'
      @trips_active = "active_trips"
    else
      @trips_active = ""

  return undefined
]