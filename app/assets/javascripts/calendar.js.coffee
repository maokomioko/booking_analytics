class @Calendar
  constructor: ->
    @roomsList()
    @selectDates()
    @clearSelection()
    @togglePriceControls()
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

  clearSelection: ->
    $(document).click (e) ->
      console.log e
      # setTimeout (->
      #   if !$(e.target).closest('#calendar').length
      #     console.log 'happened'
      #     $('#calendar td.selected').removeClass('selected')
      #   ), 1000
  togglePriceControls: ->
    $(document).click ->
      if $('td.selected').length
        $('#rs_date_list li:first-of-type').removeClass 'hidden'

        $('#rs_date_list a').click (e) ->
          e.preventDefault()

        if window.isPriceUpdLocked == false
          $('#rs_date_list a')[0].click ->
            submitDates()

          $('#rs_date_list a')[1].click ->
            $(document).trigger('manualPriceInputCalled')
            manualPriceApply()

      else
        $('#rs_date_list').addClass 'hidden'

  toggleManualPriceInput: ->
    $(document).on 'manualPriceInputCalled', ->
      $('#rs_date_list li:last-of-type').toggleClass 'hidden'

   manualPriceApply = ->
    $('#custom_price').change ->
      $val = $(@).value()
      setTimeout (->
        submitDates($val)
        ), 500

      return

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
          window.isPriceUpdLocked = true
