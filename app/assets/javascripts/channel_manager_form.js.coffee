class @ChannelManagerForm
  constructor: ->
    @initForm()

  initForm: ->
    connectorForms = {}
    $connectorSelect = $('#channel_manager_connector_type')

    return unless $connectorSelect.length

    detachFields = ->
      $('fieldset[data-connector]').map (i, el) ->
        $(el).addClass('hidden')
        connectorForms[$(el).data('connector')] = $(el).detach()
      return
    detachFields()

    showFields = (connector_type) ->
      $('.connector-fieldset').after(connectorForms[connector_type])
      $('fieldset[data-connector]').removeClass('hidden')

    if $connectorSelect.val().length > 0
      showFields($connectorSelect.val())

    $connectorSelect.on 'change', ->
      detachFields()
      showFields($(@).val())