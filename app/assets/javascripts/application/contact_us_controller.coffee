jetsetgo_app.controller 'ContactUsController', ['$http', 'notify', ($http, notify)->

	@create = ->
		return unless @validated()

	@validated = ->
		unless @name
			notify
				message: 'Name is required.'
				classes: ['alert-danger']
			return		
		unless @email
			notify
				message: 'Email is required.'
				classes: ['alert-danger']
			return
		unless @phone
			notify
				message: 'Phone is required.'
				classes: ['alert-danger']
			return		
		unless @message
			notify
				message: 'Message is required.'
				classes: ['alert-danger']

	return undefined
]