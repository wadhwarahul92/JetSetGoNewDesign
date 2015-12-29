$(document).on('ready page:load', ->
  $.each( $('.aircraft_image'), (i, e)->
    $(e).magnificPopup({
      type: 'image'
      delegate: 'img'
      gallery: { enabled: true }
    })
  )
)

$(document).on('change', '.auto-submit', ->
  $(this).parents('form').first().submit()
)