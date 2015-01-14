class @FlashMessage
  constructor: () ->
    @getAjaxResponse()
    @hidePersistent()

  getAjaxResponse: ->
    $(document).ajaxComplete (event, request) ->
      value = request.getResponseHeader("X-Message")
      key = request.getResponseHeader("X-Message-Type")
      if key? && key.split(',').length == 1
        show_ajax_message(value, key)
        hideContainer()

  hidePersistent: ->
    $(document).on 'click', "#flash_container .close", (e) ->
      e.preventDefault()
      $(@).parent().parent().slideUp 'slow'

    $(document).ready ->
      hideContainer() if $('#flash_container').html().length > 0

  show_ajax_message = (value, key) ->
    $("#flash_container").html "
      <div class='alert #{key}'>
        <strgon>#{value}</strong>
        <a href='#' class='close'></a>
      </div>
    "
    return

  hideContainer = ->
    $("#flash_container .alert").delay(5000).slideUp 'slow'