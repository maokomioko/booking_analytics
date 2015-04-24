class @Users
  constructor: ->
    @invitationSubmit()

  invitationSubmit: ->
    $form = $('.invitation-form')

    $form.on 'submit.rails', ->
      blockElemet $(@).parents('.tab-pane')

    $form.on 'ajax:complete', ->
      $(@).parents('.tab-pane').unblock()
