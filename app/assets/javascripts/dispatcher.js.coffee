class Dispatcher
  constructor: ->
    @initGlobalScripts()
    @initPageScripts()

  initGlobalScripts: ->
    window.Main.init()
    new FlashMessage()
    new Validation()

  initPageScripts: ->
    page = $('body').attr('data-page')

    unless page
      return false

    path = page.split(':')

    switch page
      when 'calendar:index'
        new Calendar()
      when 'settings:edit'
        new Settings()

ready = ->
  new Dispatcher()

$(document).on 'page:change', ready
