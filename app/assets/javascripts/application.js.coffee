#= require jquery2
#= require jquery.turbolinks
#= require turbolinks

#= require jquery_ujs
#= require jquery-ui
#= require jquery.remotipart

#= require_tree .

ready = ->
  # $("#calendar").mCustomScrollbar
  #   theme: "dark"

  window.isMouseDown = false
  $(document).mouseup ->
    window.isMouseDown = false

$(document).ready(ready)
