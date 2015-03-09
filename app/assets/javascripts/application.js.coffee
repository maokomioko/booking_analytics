#= require jquery2
# require jquery.turbolinks
#= require turbolinks

#= require jquery_ujs
#= require jquery-ui
#= require jquery.remotipart

#= require_tree .

ready = ->
  $("#calendar").perfectScrollbar()

  window.isMouseDown = false

  $(document).mouseup ->
    window.isMouseDown = false

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
