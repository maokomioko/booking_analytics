class @OverbookingRelated
  constructor: ->
    @deleteRelated()
    @bulkDeleteRelated()

  deleteRelated: ->
    $('.remove-related').on 'click', ->
      triggerSpinner()

  bulkDeleteRelated: ->
    $('.bulk-delete-related').on 'click', (e) ->
      e.preventDefault()
      params = $('[name="ids[]"]:checked').serialize()

      unless params.length
        message = $('[data-message="select_hotels_first"]').text()
        return alert(message)

      message = $('[data-message="confirm_related_bulk_delete"]').text()
      if confirm(message)
        $.ajax
          url: @href
          data: params
          method: 'POST'
          beforeSend: -> triggerSpinner()
