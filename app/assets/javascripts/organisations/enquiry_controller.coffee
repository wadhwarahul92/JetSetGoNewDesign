organisations_app.controller 'EnquiryController', ['$http', 'enquiry', ($http, enquiry)->

  @enquiry = enquiry

  @subTotal = ->
    cost = 0.0
    for activity in @enquiry.activities
      cost += activity.flight_cost
      cost += activity.handling_cost_at_takeoff
      cost += activity.landing_cost_at_arrival
      if activity.accommodation_plan and activity.accommodation_plan.cost
        cost += activity.accommodation_plan.cost
    cost

  @taxValue = (tax)->
    subTotal = @subTotal()
    ( (tax / 100) * subTotal )

  @grandTotal = ->
    grandTotal = @subTotal()
    for tax, value in @enquiry.tax
      grandTotal += @taxValue(value)
    grandTotal

  return undefined
]