jetsetgo_app.controller 'JetSetYatraEnquiryController', ['$http', 'notify', '$scope', ($http, notify, $scope)->

  @package = ['Chardham Yatra (4 Nights)', 'Dodham Yatra (2 Nights)', '1 Night Chardham Yatra', 'Hemkundsahib Yatra', 'Kedarnath Yatra', 'Muktinath Darshan - Nepal', 'Kailash And Mansarovar Yatra - Nepal']
  @enquiry = {}

  @onSetTime = (newDate, oldDate, index)->

  @beforeRenderDate = (view, dates, leftDate, upDate, rightDate, index)->
    activeDate = null
    activeDate = moment(new Date())
    for _date in dates
      if _date.localDateValue() <= activeDate.valueOf()
        _date.selectable = false

  @formatTime = (time)->
    data = null
    try
      data = moment(new Date("#{time}")).format('Do MMM YYYY, hh:mm A')
    if data and data == 'Invalid date'
      return 'Click to choose time'
    else
      return data

  @validatedActivities = ->
    unless @enquiry.name
      notify
        message: 'Name cannot be blank.'
        classes: ['alert-danger']
      return false
    unless @enquiry.email
      notify
        message: 'Email cannot be blank'
        classes: ['alert-danger']
      return false
    unless @enquiry.mobile_number
      notify
        message: 'Mobile number cannot be blank.'
        classes: ['alert-danger']
      return false
    unless @enquiry.date_of_travel
      notify
        message: 'Date of travel cannot be blank.'
        classes: ['alert-danger']
      return false
    unless @enquiry.package
      notify
        message: 'Package cannot be blank.'
        classes: ['alert-danger']
      return false
    true


  @create = ->
    return unless @validatedActivities()
    @enquiry = {
      name: @enquiry.name
      email: @enquiry.email
      mobile_number: @enquiry.mobile_number
      date_of_travel: @enquiry.date_of_travel
      package: @enquiry.package
    }

    $http.post('yatra_enquiries.json', enquiry: @enquiry).success(
      (data)->
        @enquiry = {}
        notify
          message: "Successfully saved. We'll contact you soon."
        $scope.$close()
    ).error(
      (data)->
        error = 'Something went wrong'
        try
          error = data.errors[0]
        notify
          message: error
          classes: ['alert-danger']
    )

  return undefined
]