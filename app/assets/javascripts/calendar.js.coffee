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
    $('.calendar_item').removeClass('no-right-margin')
    $('.calendar_item:not(.hidden):nth-of-type(7n)').addClass('no-right-margin')

  changeMonth: ->
    i = 0
    $('.calendar_daterange .drp_arrow').click ->

      if $(@).hasClass('next')
        i = i + 1
      else
        i = i - 1

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
    $('#calendar .calendar_item.selectable').click ->
      $(@).toggleClass 'selected'

  togglePriceControls: ->
    $(document).click ->
      if $('.calendar_item.selected').length
        notifyAboutChangedPrices()
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

  notifyAboutChangedPrices = ->
    inc_count = $('.increased.selected').length
    dec_count = $('.decreased.selected').length

    if inc_count > 0
      $('#price_inc').removeClass('hidden')
      $('#price_inc span').html(inc_count)
    else
      $('#price_inc').addClass('hidden')

    if dec_count > 0
      $('#price_dec').removeClass('hidden')
      $('#price_dec span').html(dec_count)
    else
      $('#price_dec').addClass('hidden')

    $('#prices_to_change').html(dec_count + inc_count)

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
