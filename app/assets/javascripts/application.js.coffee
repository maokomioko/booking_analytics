#= require jquery
# require turbolinks

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
#= require select2

#= require modules/main

# require jquery.turbolinks

# require_tree .

ready = ->
  $("#calendar").perfectScrollbar()

  window.isMouseDown = false

  $(document).mouseup ->
    window.isMouseDown = false

  Main.init()

  if $('.search-select').length
    $('.search-select').select2
      allowClear: true

  page = $('body').data('page')
  menu = $('li[data-menu~="' + page + '"]')

  if menu.length
    menu.addClass('active')
    menu.parents('li').addClass('open active')

  return

$(document).on "ready page:load", ready

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
