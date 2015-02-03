class @Calendar
  constructor: ->
    @roomsList()
    @selectDates()
    @togglePriceControls()
    @setPrices()
    @toggleManualPriceInput()

  roomsList: ->
    $('#room_title').click (e) ->
      e.preventDefault()
      $('#rooms_list').toggleClass('visible')

  selectDates: ->
    $('tbody td.selectable').mousedown(->
      window.isMouseDown = true

      $(@).toggleClass 'selected'
      $(@).parent().toggleClass 'with_selection'
      false

    ).mouseover ->
      if window.isMouseDown
        $(@).toggleClass 'selected'
        $(@).parent().toggleClass 'with_selection'

      return

    $(document).mouseup ->
      window.isMouseDown = false
      return

  togglePriceControls: ->
    $(document).click ->
      if $('td.selected').length
        $('#left_menu ul:first-of-type li:first-of-type').removeClass 'hidden'
      else
        $('#left_menu ul:first-of-type li:first-of-type').addClass 'hidden'
        $(document).trigger('manualPriceInputHide')

  setPrices: ->
    $('#apply_suggested').click (e) ->
      e.preventDefault()
      triggerSpinner()
      submitDates()
      $('#left_menu ul:first-of-type li:first-of-type').addClass 'hidden'

    $('#set_manually').click (e) ->
      e.preventDefault()
      $(document).trigger('manualPriceInputCalled')
      manualPriceApply()

  toggleManualPriceInput: ->
    $(document).on 'manualPriceInputCalled', ->
      $('#left_menu ul:first-of-type li:last-of-type').toggleClass 'hidden'

    $(document).on 'manualPriceInputHide', ->
      $('#left_menu ul:first-of-type li:last-of-type').addClass 'hidden'

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
    room_id = $('#room_title').attr('room_id')
    arr = []
    custom_price = $('#custom_price').val()

    $('td.selected').each ->
      arr.push $(@).attr('date')

    $.ajax
      type: "POST",
      url: window.dates_update_path,
      data: {price: custom_price, dates: arr, room_id: room_id},
      success: ->
          $('td.selected .container').addClass('with_auto_price').removeClass('selected')
          if custom_price > 0
            $('td.selected .container .manual').removeClass 'hidden'

          window.isPriceUpdLocked = true
          triggerSpinner()
