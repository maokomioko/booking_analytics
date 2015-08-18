class @Calendar
  constructor: ->
    connector = $('#calendar').data('channelManager')
    return if connector == 'empty'

    @roomsList()
    @changeMonth()
    @selectDates()
    @togglePriceControls()
    @setPrices()

    removeTileMargins()

  roomsList: ->
    $('#room_title').click (e) ->
      e.preventDefault()
      $('#rooms_list').toggleClass('visible')


  removeTileMargins = ->
    $('.calendar_item:not(.hidden):nth-of-type(7n').css('margin-right: 0')

  changeMonth: ->
    i = 0
    $('.calendar_daterange .drp_arrow').click ->

      if $(@).hasClass('next')
        i = i + 1
      else
        i = i - 1

      console.log i

      switch i
        when 0
          $(@).addClass('hidden')
          $('.current_month').removeClass('hidden')
          $('.next_month').toggleClass('hidden')
        when 1
          $('.current_month').addClass('hidden')
          $('.next_month').toggleClass('hidden')
          $('.last_month').addClass('hidden')
          $(@).siblings('.prev').removeClass('hidden')
          $(@).siblings('.next').removeClass('hidden')
        when 2
          $('.next_month').toggleClass('hidden')
          $('.last_month').toggleClass('hidden')
          $(@).addClass('hidden')

      removeTileMargins()

  selectDates: ->
    $('#calendar .calendar_item:not(.past)').mousedown(->
      window.isMouseDown = true

      $(@).toggleClass 'selected'
      false

    ).mouseenter (e) ->
      if window.isMouseDown
        $(@).toggleClass 'selected'
      return

    $(document).mouseup ->
      window.isMouseDown = false
      return

  togglePriceControls: ->
    $(document).click ->
      if $('.calendar_item.selected').length
        $('#price_control').removeClass 'hidden'
      else
        $('#price_control').addClass 'hidden'

  setPrices: ->
    $('.modal .btn_apply').click (e) =>
      e.preventDefault()
      $('.modal').modal('hide')

    $('#apply_suggested .btn_apply').click (e) =>
      triggerSpinner()
      submitDates()

    $('#set_manually .btn_apply').click (e) ->
      if $('#custom_price').val()
        triggerSpinner()
        submitDates()

  submitDates = ->
    room_id = $('#calendar').data('roomId')
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
