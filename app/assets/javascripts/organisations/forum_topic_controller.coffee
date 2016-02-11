organisations_app.controller 'ForumTopicController', ['$http', 'notify', ($http, notify)->

  @forum_topic = {}

  @create = ->
    $http.post('/organisations/forum_topics.json', @forum_topic).success(
      ->
        notify(
          message: 'New Froum Topic created.'
        )
        Turbolinks.visit('/organisations/forum_topics')
    ).error(
      (data)->
        error = 'Something went wrong.'
        try
          error = data.errors[0]
        notify(
          message: error
          classes: ['alert-danger']
        )
    )

  return undefined
]