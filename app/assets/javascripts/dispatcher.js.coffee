class Dispatcher
  constructor: ->
    @initPageScripts()

  initPageScripts: ->
    page = $('body').attr('data-page')

    unless page
      return false

    path = page.split(':')

    switch page
      when 'calendar:index'
        new Calendar()

ready = ->
  new Dispatcher()

$(document).ready(ready)
