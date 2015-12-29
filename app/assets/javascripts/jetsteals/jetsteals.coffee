$(document).on('change', '.auto-submit', ->
  $(this).parents('form').first().submit()
)