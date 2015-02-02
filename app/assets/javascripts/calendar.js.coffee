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

  setPrices: ->
    $('#left_menu a').click (e) ->
      e.preventDefault()

    $('#apply_suggested').click ->
      submitDates()
      $('#left_menu ul:first-of-type li:first-of-type').addClass 'hidden'
      $('#calendar td.selected').removeClass('selected')

    $('#set_manually').click ->
      $(document).trigger('manualPriceInputCalled')
      manualPriceApply()

  toggleManualPriceInput: ->
    $(document).on 'manualPriceInputCalled', ->
      $('#left_menu ul:first-of-type li:last-of-type').toggleClass 'hidden'

   manualPriceApply = ->
    $('#custom_price').keypress ->
      $val = $(@).val()
      setTimeout (->
        modalConfirmation() if $val > 0
        false
        ), 1000
      false

  modalConfirmation = ->
    $('#dialog-confirm').dialog
      resizable: false
      width: 400
      height: 200
      modal: true
      buttons:
        'Apply custom price': ->
          $(@).dialog 'close'
          submitDates()
          $(document).trigger('manualPriceInputCalled')
          return
        Cancel: ->
          $(@).dialog 'close'
          return

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
          $('td.selected .container').addClass('with_applied_price').removeClass('selected')
          if custom_price > 0
            $('td.selected .container').addClass('with_lock')

          window.isPriceUpdLocked = true
