class @OverbookingPartner
  constructor: ->
    @initBulkActionButton()
    @bulkOverbooking()

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

  bulkOverbooking: ->
    $('.bulk-overbooking').on 'click', (e) ->
      e.preventDefault()

      params = $('[name="ids[]"]:checked').serialize()

      $.ajax
        url: @href
        data: params
        method: 'POST'
        beforeSend: -> triggerSpinner()
