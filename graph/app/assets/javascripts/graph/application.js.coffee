#= require_tree .
#= require_self
#
graphReady = ->
  new RangeSlider()

$(document).on "ready page:load", graphReady
