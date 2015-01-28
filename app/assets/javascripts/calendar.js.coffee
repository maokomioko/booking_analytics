class @Calendar
  constructor: ->
    @roomsList()
    @selectDates()
    @clearSelection()
    @togglePriceControls()

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

        #submitDates()
        #if $(@).siblings('.selected').length

        #if $(@).parent().siblings('.with_selection').length

      return

    $(document).mouseup ->
      window.isMouseDown = false
      setTimeout (->
        $(document).trigger('contentClicked')
        false
        ), 1000
      return

  clearSelection: ->
    $(document).click (e) ->
      if !$(event.target).closest('#calendar').length
        $('#calendar td.selected').removeClass('selected')

  togglePriceControls: ->
    $(document).on 'contentClicked', ->
      if $('td.selected').length
        $('#rs_date_list').removeClass 'hidden'

        $('#rs_date_list a:first-of-type').click (e) ->
          e.preventDefault()
          submitDates()
      else
        $('#rs_date_list').addClass 'hidden'

  submitDates = ->
    room_id = $('#room_title').attr('room_id')
    arr = []
    $('td.selected').each ->
      arr.push $(@).attr('date')

    $.ajax
      type: "POST",
      url: window.dates_update_path,
      data: {dates: arr, room_id: room_id},
      success: $('td.selected .container').addClass('with_applied_price')
