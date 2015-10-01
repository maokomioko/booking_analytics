class Dispatcher
  constructor: ->
    @initGlobalScripts()
    @initPageScripts()

  initGlobalScripts: ->
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
        new RelatedHotels()
      when 'settings:edit'
        new MapBuilder()
        new Settings()
        new RelatedHotels()
        new ChannelManagerForm()
      when 'reservations:index'
        new MapBuilder()
        new Reservation()
      when 'users:index'
        new Users()
      when 'payments:details'
        new Subscription()
      when 'wizard:step1', 'wizard:step5'
        new OverbookingContact()
        new Settings()

    if page.match(/wizard:step/i)
      new Wizard()
      new ChannelManagerForm() # step 2
      new RelatedHotels() # step 5

ready = ->
  new Dispatcher()

$(document).on 'page:change', ready
