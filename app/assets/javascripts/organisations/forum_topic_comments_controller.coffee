organisations_app.controller 'ForumTopicCommentsController', ['$http', 'notify', ($http, notify)->

  @forum_topic_id = null

  url_split = location.pathname.match(/\/organisations\/forum_topics\/(\d+)/)
  if url_split and url_split[1]
    @forum_topic_id = url_split[1]
  else
    Turbolinks.visit('/organisations/forum_topics')

  @forum_topic_comments = []

  @newComment = {}

  $http.get("/organisations/forum_topics/#{@forum_topic_id}/forum_topic_comments").success(
    (data)=>
      if data
        @forum_topic_comments = data
  ).error(
    ->
      notify(
        message: 'Could not fetch forum topic comments. Try again.'
        classes: ['alert-danger']
      )
  )

  @addNewComment = ->
    $http.post("/organisations/forum_topics/#{@forum_topic_id}/forum_topic_comments.json", @newComment).success(
      (data)=>
        notify(
          message: 'Comment added.'
        )
        @forum_topic_comments.push(data)
        @newComment = {}
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