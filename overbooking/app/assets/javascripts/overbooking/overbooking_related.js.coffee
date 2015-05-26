class @OverbookingRelated
  constructor: ->
    @deleteRelated()
    @addRelated()
    @initBulkActionButton()
    @bulkDeleteRelated()
    @bulkOverbooking()
    @initSelect2RelatedSearch()

  deleteRelated: ->
    $('.remove-related').on 'click', -> triggerSpinner()

  addRelated: ->
    $('.add-related-form').on 'submit.rails', -> triggerSpinner()

  initBulkActionButton: ->
    $button = $('.bulk-action-button')

    toggler = ->
      if $('[name="ids[]"]:checked').length
        $button.attr("disabled", false)
      else
        $button.attr("disabled", true)

    toggler()

    $('[name="ids[]"]').on 'ifChanged', ->
      toggler()
      $button.parent().removeClass('open') # hack. manual close bootstrap dropdown

  bulkDeleteRelated: ->
    $('.bulk-delete-related').on 'click', (e) ->
      e.preventDefault()
      params = $('[name="ids[]"]:checked').serialize()

      message = $('[data-message="confirm_related_bulk_delete"]').text()
      if confirm(message)
        $.ajax
          url: @href
          data: params
          method: 'POST'
          beforeSend: -> triggerSpinner()

  bulkOverbooking: ->
    $('.bulk-overbooking').on 'click', (e) ->
      e.preventDefault()

      params = $('[name="ids[]"]:checked').serialize()

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
