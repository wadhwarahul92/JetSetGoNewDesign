#/admin/jetsteals/1/jetsteal_seats
initial_seat_color = 'gray'
stroke_highlight_color = 'black'
stroke_highlight_width = '2px'
seat_cost_filled_color = 'green'

$(document).on('ready page:load', ->
  seats = $('path').filter(->
    return this.id.match(/^seat\d/)
  )
  seats.css('fill', initial_seat_color)
  seats.on('mouseenter', ->
    id = $(this).attr('id')
    $(this).css(
      'stroke': stroke_highlight_color
      'stroke-width': stroke_highlight_width
    )
    $(".seat_field[data-ui-seat-id=#{id}]").css('border', '1px solid gray')
  ).on('mouseleave', ->
    id = $(this).attr('id')
    $(this).css(
      'stroke': 'none'
    )
    $(".seat_field[data-ui-seat-id=#{id}]").css('border', 'none')
  )
)

$(document).on('mouseenter', '.seat_field', ->
  ui_seat_id = $(this).attr('data-ui-seat-id')
  if ui_seat_id
    $(this).css('border', '1px solid gray')
    $("path##{ui_seat_id}").css(
      'stroke': stroke_highlight_color
      'stroke-width': stroke_highlight_width
    )
).on('mouseleave', '.seat_field', ->
  ui_seat_id = $(this).attr('data-ui-seat-id')
  if ui_seat_id
    $(this).css('border', 'none')
    $("path##{ui_seat_id}").css('stroke', 'none')
)

$(document).on('change', '.jetsteal_jetsteal_seats_cost input', ->
  value = parseInt( $(this).val() )
  ui_seat_id = $(this).parents('.seat_field').first().attr('data-ui-seat-id')
  if value and value > 0
    $("path##{ui_seat_id}").css('fill', seat_cost_filled_color)
  else
    $("path##{ui_seat_id}").css('fill', initial_seat_color)
)
#/admin/jetsteals/1/jetsteal_seats