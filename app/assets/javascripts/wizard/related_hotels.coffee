class @RelatedHotels
  constructor: ->
    @deleteRelated()
    @addRelated()
    @relatedPartnersUpdate()
    RelatedHotels.initSelect2RelatedSearch()

  deleteRelated: ->
    $('body').on 'click', '.remove-related', -> blockRowElement $(@).parents('tr')

  addRelated: ->
    $('body').on 'submit.rails', '.add-related-form', ->
      blockElement($('[data-partial="related_hotels"]'))

  relatedPartnersUpdate: ->
    $(document).on 'ajax:success', '.bulk-overbooking', ->
      blockRowElement $(@).parents('tr')
      $(@).parent().find('.bulk-overbooking.hidden').removeClass('hidden')
      $(@).addClass('hidden')
      unblockRowElement $(@).parents('tr')

  @initSelect2RelatedSearch: ->
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
