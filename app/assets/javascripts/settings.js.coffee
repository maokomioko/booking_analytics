class @Settings
  constructor: ->
    @roomSubmit()
    @settingsSubmit()

  roomSubmit: ->
    $form = $('form[data-room-id]')

    $form.on 'submit.rails', ->
      blockElemet $(@).parents('.panel')

    $form.on 'ajax:complete', ->
      $(@).parents('.panel').unblock()

  settingsSubmit: ->
    $form = $('.settings-form')

    $form.on 'submit.rails', ->
      blockElemet $(@).parents('.tab-pane')

    $form.on 'ajax:complete', ->
      $(@).parents('.tab-pane').unblock()