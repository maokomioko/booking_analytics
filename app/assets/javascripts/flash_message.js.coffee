class @FlashMessage

  constructor: () ->
    @container = $('#flash-container')
    @getAjaxResponse()
    @hidePersistent()

  getAjaxResponse: ->
    $(document).ajaxComplete (event, request) =>
      value = request.getResponseHeader("X-Message-Html")
      key = request.getResponseHeader("X-Message-Type")
      @container.html(value)
      @hideContainer()

  hidePersistent: ->
    $(document).on 'click', "#flash-container .close", (e) ->
      e.preventDefault()
      @hideContainer(0)

    $(document).ready =>
      @hideContainer() if @container.length && @container.html().length

  show_ajax_message: (value, key) ->
    $("#flash_container").html "
      <div class='alert #{key}'>
        <strgon>#{value}</strong>
        <a href='#' class='close'></a>
      </div>
    "
    return

  hideContainer: (delay = 5000) ->
    @container.delay(delay).slideUp 'slow', ->
      $(@).empty().show()
