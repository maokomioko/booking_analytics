class @Calendar
  constructor: ->
    connector = $('#calendar').data('channelManager')
    return if connector == 'empty'

    @priceControl = $('#price_control')
    @roomsList()
    @removeSelectableFromEmptyCells()
    @selectDates()
    @togglePriceControls()
    @setPrices()
    @toggleManualPriceInput()

  roomsList: ->
    $('#room_title').click (e) ->
      e.preventDefault()
      $('#rooms_list').toggleClass('visible')

  removeSelectableFromEmptyCells: ->
    $('#calendar td.selectable:empty').removeClass('selectable')

  selectDates: ->
    $('tbody td.selectable').mousedown(->
      window.isMouseDown = true

      $(@).toggleClass 'selected'
      $(@).parent().toggleClass 'with_selection'
      false

    ).mouseenter (e) ->
      if window.isMouseDown
        $(@).toggleClass 'selected'
        $(@).parent().toggleClass 'with_selection'

      return

    $(document).mouseup ->
      window.isMouseDown = false
      return

  togglePriceControls: ->
    $panel = @priceControl.find('[data-role="panel"]')

    $(document).click ->
      if $('td.selected').length
        $panel.removeClass 'hidden'
      else
        $panel.addClass 'hidden'
        $(document).trigger('manualPriceInputHide')

  setPrices: ->
    $('#apply_suggested').click (e) =>
      e.preventDefault()
      triggerSpinner()
      submitDates()
      @priceControl.find('[data-role="panel"]').addClass 'hidden'

    $('#set_manually').click (e) ->
      e.preventDefault()
      $(document).trigger('manualPriceInputCalled')
      manualPriceApply()

  toggleManualPriceInput: ->
    $manual = @priceControl.find('[data-role="manual"]')

    $(document).on 'manualPriceInputCalled', ->
      $manual.toggleClass 'hidden'

    $(document).on 'manualPriceInputHide', ->
      $manual.addClass 'hidden'

    $(document).on 'manualPriceInputCalled', 'manualPriceInputHide', ->
      $('#custom_price').val(0)

   manualPriceApply = ->
    $('#apply_custom_price').click (e) ->
      e.preventDefault()

      if $('#custom_price').val()
        triggerSpinner()
        submitDates()
        $(document).trigger('manualPriceInputCalled')

  submitDates = ->
    room_id = $('.calendar').data('roomId')
    arr = []
    custom_price = $('#custom_price').val()

    $('td.selected').each ->
      arr.push $(@).attr('date')

    $.ajax
      type: "POST",
      url: window.dates_update_path,
      data: {price: custom_price, dates: arr, room_id: room_id},
      success: ->
        triggerSpinner()
        Turbolinks.visit location.toString()
