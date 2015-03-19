#= require jquery2
# require jquery.turbolinks
#= require turbolinks

#= require jquery_ujs
#= require jquery-ui
#= require jquery.remotipart

#= require bootstrap-sprockets
#= require bootstrap-hover-dropdown.min

#= require jquery.blockUI

#= require icheck
#= require jquery.mousewheel
#= require perfect-scrollbar
#= require jquery.cookie

#= require modules/main

# require_tree .

ready = ->
  $("#calendar").perfectScrollbar()

  window.isMouseDown = false

  $(document).mouseup ->
    window.isMouseDown = false

  Main.init()

$(document).ready(ready)

# Turbolinks spinner and another one for displaying in photo uploading boxes
$(document).on "page:fetch", ->
  triggerSpinner()

$(document).on "page:receive", ->
  triggerSpinner()

$(document).on "eventFormSent", ->
  triggerSpinner()

window.triggerSpinner = ->
  $("#spinner_placeholder").toggleClass "hidden"
  $("html").toggleClass "no-scroll"
  return
