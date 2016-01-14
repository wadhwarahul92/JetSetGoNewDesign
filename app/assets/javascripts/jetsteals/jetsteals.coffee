$(document).on('ready page:load', ->
  $.each( $('.aircraft_image'), (i, e)->
    $(e).magnificPopup({
      type: 'image'
      delegate: 'img'
      gallery: { enabled: true }
    })
  )

  #click on btn if params btn_click present
  if location.search.match(/btn_click/)
    btn_id = location.search.split('btn_click=')[1]
    $("##{btn_id}")[0].click()
  #########################################

)

$(document).on('change', '.auto-submit', ->
  $(this).parents('form').first().submit()
)