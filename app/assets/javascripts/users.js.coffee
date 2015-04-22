class @Users
  constructor: ->
    @submitInviteForm()

  submitInviteForm: ->
    $('.invitation-form-submit').on 'click', (e) ->
      e.preventDefault()
      $('.invitation-form').trigger('submit.rails')