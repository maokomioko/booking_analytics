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
    $('#custom_price').change ->
      $val = $(@).val()
      setTimeout (->
        submitDates($val)
        #$(document).trigger('manualPriceInputCalled')
        false
        ), 5000

      false

  submitDates = (custom_price = null) ->
    room_id = $('#room_title').attr('room_id')
    arr = []
    $('td.selected').each ->
      arr.push $(@).attr('date')

    $.ajax
      type: "POST",
      url: window.dates_update_path,
      data: {price: custom_price, dates: arr, room_id: room_id},
      success: ->
          $('td.selected .container').addClass('with_applied_price')
          if custom_price > 0
            $('td.selected .container').addClass('with_lock')
          window.isPriceUpdLocked = true
