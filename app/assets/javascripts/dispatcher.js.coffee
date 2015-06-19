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
      when 'calendar:index', 'calendar:demo'
        new Calendar()
      when 'related_hotels:edit'
        new Related()
      when 'settings:edit'
        new Settings()
      when 'users:index'
        new Users()

    if page.match(/wizard:step/i)
      new Wizard()
      new Related() # step 5

ready = ->
  new Dispatcher()

$(document).on 'page:change', ready
