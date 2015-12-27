#jetsteal = angular.module 'jetsteal', []
#
#jetsteal.controller 'JetstealController', ['$http', ($http)->
#
#  diabled_seat_color = 'red'
#
#  available_seat_color = 'rgb(238, 200, 47)'
#
#  @jetsteal = {}
#
#  url_array = location.pathname.split('/')
#
#  jetsteal_id = parseInt( url_array[url_array.length-1] )
#
##  console.log("Fetching jetsteal id #{jetsteal_id}")
#
#  $http.get("/jetsteals/#{jetsteal_id}.json").success(
#    (data)=>
#      if data
#        @jetsteal = data
#        $('#plane-svg').append(@jetsteal.aircraft.aircraft_type.svg)
#        @jetsteal_seats = @jetsteal.jetsteal_seats
#        for jetsteal_seat in @jetsteal_seats
#          s = $("##{jetsteal_seat.ui_seat_id}")
#          s.css('fill', available_seat_color)
#          if jetsteal_seat.disabled
#            s.css('fill', diabled_seat_color)
#      else
#        console.error "Error fetching jetsteal id #{jetsteal_id}"
#  ).error(
#    ->
#      console.error "Error fetching jetsteal id #{jetsteal_id}"
#  )
#
#  return undefined
#]