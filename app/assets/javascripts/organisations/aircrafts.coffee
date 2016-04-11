organisations_app.controller 'AircraftsController', ['$http', 'notify', '$upload', 'AircraftsService', ($http, notify, $upload, AircraftsService)->
  
  @selectedAircraftId = null

  @aircrafts = []

  AircraftsService.getAircraftsForCurrentOperator().then(
    =>
      @aircrafts = AircraftsService.aircraftsForCurrentOperator
      try
        @selectedAircraftId = @aircrafts[0].id
  )

#  $http.get('/organisations/aircrafts.json').success(
#    (data)=>
#      @aircrafts = data
#  ).error(
#    ->
#      notify(
#        message: 'Error fetching aircrafts'
#        classes: ['alert-danger']
#      )
#  )

  @uploadAircraftImage = (files, aircraft)->
    $upload.upload(
      file: files[0]
      url: "/organisations/aircrafts/#{aircraft.id}/aircraft_images"
    ).success(
      (data)=>
        unless aircraft.aircraft_images
          aircraft.aircraft_images = []
        aircraft.aircraft_images.push(data)
    ).error(
      (data)->
        error = 'Something went wrong'
        try
          error = data.errors[0]
        notify(
          message: error
          classes: ['alert-danger']
        )
    )

  @deleteAircraftImage = (image, aircraft)->
    bootbox.confirm('Are you sure?', (result)->
      if result
        $http.delete("/organisations/aircrafts/#{aircraft.id}/aircraft_images/#{image.id}").success(
          =>
            aircraft.aircraft_images.splice( aircraft.aircraft_images.indexOf(image), 1 )
        ).error(
          ->
            notify(
              message: 'Error deleting image, try again'
              classes: ['alert-danger']
            )
        )
    )
    null

  return undefined
]