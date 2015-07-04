class @OverbookingContact
  constructor: ->
    $.fn.modalmanager.defaults.resize = true;
    @initModals()

  initModals: ->
    $modal = $('#ajax-modal')

    $('.ajax[data-toggle="modal"]').on 'click', (e) ->
      triggerSpinner()

      href = $(@).data('href')

      $.ajax
        url: href
        method: 'GET'
        success: (data) ->
          $modal.html(data)
          $modal.modal()
          OverbookingContact.initForm()
        complete: ->
          triggerSpinner()

    $modal.on 'submit.rails', 'form', -> triggerSpinner()
    $modal.on 'ajax:complete', 'form', -> triggerSpinner()

  @initForm: ->
    contactForms = {}
    $contactSelect = $('#contact_contact_type')

    return unless $contactSelect.length

    $('fieldset[data-contact] .phone').inputmask('phone')
    $('fieldset[data-contact] .email').inputmask('email')

    detachFields = ->
      $('fieldset[data-contact]').map (i, el) ->
        $(el).addClass('hidden')
        contactForms[$(el).data('contact')] = $(el).detach()
      return
    detachFields()

    showFields = (connector_type) ->
      $('.contact-fieldset').after(contactForms[connector_type])
      $('fieldset[data-contact]').removeClass('hidden')

    if $contactSelect.val().length > 0
      showFields($contactSelect.val())

    $contactSelect.on 'change', ->
      detachFields()
      showFields($(@).val())