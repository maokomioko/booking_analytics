class @Users
  constructor: ->
    @invitationSubmit()

  invitationSubmit: ->
    $form = $('.invitation-form')

    $form.on 'submit.rails', ->
      blockElement $(@).parents('.tab-pane')

    $form.on 'ajax:complete', ->
      $(@).parents('.tab-pane').unblock()
