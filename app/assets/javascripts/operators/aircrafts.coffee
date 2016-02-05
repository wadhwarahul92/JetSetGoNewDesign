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
        aircraft.aircraft_images.push(data.aircraft_image)
    ).error(
      (data)->
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )

  return undefined
]