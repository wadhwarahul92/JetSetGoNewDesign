organisations_app.controller "SettingsController", ['$http', 'notify', '$upload', '$uibModal', ($http, notify, $upload, $uibModal) ->

  @newDocument = {}

  @terms_and_condition = null

  @documents = []

  @toggleOperator = (id)->
    $http.put("/organisations/operators/#{id}/toggle.json").success(
      ->
        Turbolinks.visit('/organisations/settings')
    ).error(
      (data)->
        error = 'Something went wrong.'
        try
          error = data.errors[0]
        notify
          message: error
          classes: ['alert-danger']
    )

  @get_t_and_c = ->
    $http.get("/organisations/operators/get_terms_and_condition.json").success(
      (data)=>
        @terms_and_condition = data.terms_and_condition
    ).error(
      (data)->
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )

  @update_t_and_c = ->
    $http.put("/organisations/operators/set_terms_and_condition.json", {t_and_c: @terms_and_condition}).success(
      ->
        notify(
          message: 'Terms and condition successfully saved.'
        )
    ).error(
      (data)->
        notify(
          message: data.errors[0]
          classes: ['alert-danger']
        )
    )

  @getDocuments = ->
    $http.get('/organisations/organisation_documents.json').success(
      (data)=>
        @documents = data
    ).error(
      ->
        notify
          message: 'Error fetching documents, ERROR10098'
          classes: ['alert-danger']
    )

  @addStaticFile = (files)->
    return unless files[0]
    modal = $uibModal.open(
      size: 'sm'
      template: """
      <h3 class="text-center"><i class="fa fa-circle-o-notch fa-spin"></i> Hang tight while we upload the file to our servers.<h3>
      """
    )
    $upload.upload(
      file: files[0]
      url: '/static_files.json'
    ).success(
      (data)=>
        @newDocument.static_file_id = data.id
        modal.close()
    ).error(
      (data)->
        error = 'Error uploading document. Please try again.'
        try
          error = data.errors[0]
        notify
          message: error
          classes: ['alert-danger']
        modal.close()
    )

  @create = ->
    $http.post('/organisations/organisation_documents.json', {organisation_document: @newDocument}).success(
      (data)=>
        notify
          message: 'New document successfully added.'
        @newDocument = {}
        @documents.push data
    ).error(
      (data)->
        error = 'Something went wrong. Could not create new document.'
        try
          error = data.errors[0]
        notify
          message: error
          classes: ['alert-danger']
    )

  @delete = (document)->
    bootbox.confirm('Are you sure?', (result)=>
      if result
        $http.delete("/organisations/organisation_documents/#{document.id}.json").success(
          =>
            notify
              message: 'Document removed successfully.'
            @documents.splice( @documents.indexOf(document), 1 )
        ).error(
          ->
            notify
              message: 'Unable to remove document. Error 1x0009'
              classes: ['alert-danger']
        )
    )
    return undefined

  return undefined
]