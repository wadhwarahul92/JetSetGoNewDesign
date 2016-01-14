$(document).on('ready page:load', ->
  total_minutes = ''
  hours_in_minutes = ''
  minutes = ''
  $('.jetsteals-form .hour').on('blur', ->
      hours_in_minutes = parseInt(this.value) * 60
      total_minutes = (parseInt(hours_in_minutes) + parseInt(minutes)).toString()
      if $('.jetsteals-form .hour').val() != '' && $('.jetsteals-form .minute').val() != ''
        $('.jetsteals-form #jetsteal_flight_duration_in_minutes').val(total_minutes)
      else
        $('.jetsteals-form #jetsteal_flight_duration_in_minutes').val('')
  )
  $('.jetsteals-form .minute').on('blur', ->
      minutes = parseInt(this.value)
      total_minutes = (parseInt(hours_in_minutes) + parseInt(minutes)).toString()
      if $('.jetsteals-form .hour').val() != '' && $('.jetsteals-form .minute').val() != ''
        $('.jetsteals-form #jetsteal_flight_duration_in_minutes').val(total_minutes)
      else
        $('.jetsteals-form #jetsteal_flight_duration_in_minutes').val('')
  )
)