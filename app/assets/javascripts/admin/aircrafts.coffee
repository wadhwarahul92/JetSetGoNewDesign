#$(document).on('click', '.add_aircraft_image_fields', ->
#  $sampleAircraftImageFields = $('.aircraft_image').first()
#  if $sampleAircraftImageFields
#    className = $sampleAircraftImageFields[0].className
#    $newDiv = $("<div class=\"#{className}\"></div>")
#    html = $sampleAircraftImageFields.html()
#    newId = new Date().getTime()
#    html = html.replace(/\[\d+\]/g, "[#{newId}]")
#    html = html.replace(/aircraft_aircraft_images_attributes_\d+/g, "aircraft_aircraft_images_attributes_#{newId}")
#    $newDiv.append($(html))
#    $(this).before $newDiv
#)