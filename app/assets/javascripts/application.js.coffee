#= require jquery2

#= require jquery_ujs
#= require jquery-ui
#= require jquery.remotipart

#= require_tree .

ready = ->
  $("#calendar").perfectScrollbar()

  window.isMouseDown = false
  window.isPriceUpdLocked = false

  $(document).mouseup ->
    window.isMouseDown = false

$(document).ready(ready)
