class @FlashMessage
  constructor: () ->
    @container = $('#flash-container')
    @getAjaxResponse()
    @hidePersistent()

  getAjaxResponse: ->
    $(document).ajaxComplete (event, request) =>
      value = request.getResponseHeader("X-Message-Html")
      key = request.getResponseHeader("X-Message-Type")
      if key? && key.split(',').length == 1
        @show_ajax_message(value, key)
        @hideContainer()

  hidePersistent: ->
    $(document).on 'click', "#flash-container .close", (e) =>
      e.preventDefault()
      @hideContainer(0)

    $(document).ready =>
      @hideContainer() if @container.length && @container.html().length

  show_ajax_message: (value, key) ->
    @container.html "
      #{value}
    "
    return

  hideContainer: (delay = 5000) ->
    @container.delay(delay).slideUp 'slow', ->
      $(@).empty().show()
