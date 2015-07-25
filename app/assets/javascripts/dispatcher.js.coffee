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
      when 'channel_manager:edit', 'channel_manager:new'
        new ChannelManagerForm()
      when 'related_hotels:edit'
        new Related()
      when 'settings:edit'
        new Settings()
        new Related()
        new ChannelManagerForm()
      when 'users:index'
        new Users()
      when 'wizard:step1', 'wizard:step5'
        new OverbookingContact()

    if page.match(/wizard:step/i)
      new Wizard()
      new ChannelManagerForm() # step 2
      new Related() # step 5

ready = ->
  new Dispatcher()

$(document).on 'page:change', ready
