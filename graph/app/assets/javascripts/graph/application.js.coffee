#= require_tree .
#= require_self
#
graphReady = ->
  page = $('body').attr('data-page')

  switch page
    when 'related_hotels:edit', 'graph:hotels:index'
      new RangeSlider()

$(document).on "ready page:load", graphReady
