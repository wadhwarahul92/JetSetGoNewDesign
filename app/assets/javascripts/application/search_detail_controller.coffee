jetsetgo_app.controller 'SearchDetailController', ['$http', 'notify', 'detail','tax','AirportsService', ($http, notify, detail, tax, AirportsService)->

  @detail = detail

  @airports = []

  @tax = tax

  @tax_in_rupees = 0.0

  AirportsService.getAirports().then(
    =>
      @airports = AirportsService.airports
  )

  @totalTripCost = ->
    trip = @detail
    cost = 0.0
    for flight_plan in trip.flight_plan
      cost += flight_plan.flight_cost
      cost += flight_plan.handling_cost_at_takeoff
      cost += flight_plan.landing_cost_at_arrival
      if flight_plan.watch_hour_at_arrival
        cost += flight_plan.watch_hour_cost
      if flight_plan.chosen_intermediate_plan
        chosen_plan = flight_plan[flight_plan.chosen_intermediate_plan]
        if chosen_plan and flight_plan.chosen_intermediate_plan == 'empty_leg_plan'
          for empty_leg in chosen_plan
            cost += empty_leg.flight_cost
            cost += empty_leg.handling_cost_at_takeoff
            cost += empty_leg.landing_cost_at_arrival
            if empty_leg.watch_hour_at_arrival
              cost += empty_leg.watch_hour_cost
        if chosen_plan and flight_plan.chosen_intermediate_plan == 'accommodation_plan'
          cost += chosen_plan.cost
    @tax_in_rupees = (cost * @tax/100)
    cost + ((@tax / 100) * cost)

  @airportForId = (id)->
    _.find(@airports, {id: id})

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, h:mm:ss A')
    data

  return undefined
]