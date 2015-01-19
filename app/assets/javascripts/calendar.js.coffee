class @Calendar
  constructor: ->
    @roomsList()
    @selectDates()
    @clearSelection()

  roomsList: ->
    $('#room_title').click (e) ->
      e.preventDefault()
      $('#rooms_list').toggleClass('visible')

  selectDates: ->

    $('tbody td').mousedown(->
      window.isMouseDown = true

      $(@).toggleClass 'selected'
      $(@).parent().toggleClass 'with_selection'

      false

    ).mouseover ->
      if window.isMouseDown
        $(@).toggleClass 'selected'
        $(@).parent().toggleClass 'with_selection'

        #if $(@).siblings('.selected').length

        #if $(@).parent().siblings('.with_selection').length

      return

    $(document).mouseup ->
      window.isMouseDown = false
      return

  clearSelection: ->
    $(document).click (e) ->
      console.log $(e.target)
      if !$(event.target).closest('#calendar').length
        $('#calendar td.selected').removeClass('selected')
