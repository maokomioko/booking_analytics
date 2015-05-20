class @OverbookingRelated
  constructor: ->
    @deleteRelated()
    @addRelated()
    @bulkDeleteRelated()
    @initSelect2RelatedSearch()

  deleteRelated: ->
    $('.remove-related').on 'click', -> triggerSpinner()

  addRelated: ->
    $('.add-related-form').on 'submit.rails', -> triggerSpinner()

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

  initSelect2RelatedSearch: ->
    $select = $('#add_related_select2')

    $select.select2
      placeholder: $('[data-message="related_search_prompt"]').text()
      multiple: true
      containerCss:
        width: '100%'
      ajax:
        url: $select.data('url')
        dataType: 'json'
        quietMillis: 250
        data: (term, page) -> { q: term }
        results: (data, page) ->
          { results: data }

    return
