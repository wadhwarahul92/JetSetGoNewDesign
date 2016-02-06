operator_app.controller 'AircraftsController', ['$http', 'notify', '$upload', ($http, notify, $upload)->

  @aircrafts = []

  $http.get('/operators/aircrafts.json').success(
    (data)=>
      @aircrafts = data
  ).error(
    ->
      notify(
        message: 'Error fetching aircrafts'
        classes: ['alert-danger']
      )
  )

  @uploadAircraftImage = (files, aircraft)->
    $upload.upload(
      file: files[0]
      url: "/operators/aircrafts/#{aircraft.id}/aircraft_images"
    ).success(
      (data)=>
        unless aircraft.aircraft_images
          aircraft.aircraft_images = []
        aircraft.aircraft_images.push(data)
    ).error(
      (data)->
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )

  @deleteAircraftImage = (image, aircraft)->
    bootbox.confirm('Are you sure?', (result)->
      if result
        $http.delete("/operators/aircrafts/#{aircraft.id}/aircraft_images/#{image.id}").success(
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

  return undefined
]