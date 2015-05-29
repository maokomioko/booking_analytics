class OverbookingDispatcher
  constructor: ->
    @initPageScripts()

  initPageScripts: ->
    page = $('body').attr('data-page')

    unless page
      return false

    switch page
      when 'overbooking:related_hotels:edit'
        new OverbookingRelated()
      when 'overbooking:directions:show'
        new Directions()

    return

ready = ->
  new OverbookingDispatcher()

$(document).on 'page:change', ready