#= require jquery2

#= require jquery_ujs

# require jquery-ui/core
# require jquery-ui/widget
#= require jquery-ui/mouse
# require jquery-ui/position
# require jquery-ui/draggable
# require jquery-ui/resizable

#= require jquery.remotipart

# require bootstrap/affix
#= require bootstrap/alert
# require bootstrap/button
# require bootstrap/carousel
#= require bootstrap/collapse
#= require bootstrap/dropdown
#= require bootstrap/modal
# require bootstrap/popover
# require bootstrap/scrollspy
#= require bootstrap/tab
#= require bootstrap/tooltip
#= require bootstrap/transition

#= require bootstrap-hover-dropdown.min
#= require bootstrap-tagsinput
#= require bootstrap-fileupload.min

#= require jquery.blockUI

#= require jquery.mousewheel
#= require jquery.cookie
#= require select2

#= require jquery.validate

#= require graph/application

#= require_tree ../../../vendor/assets/javascripts/
#= require_tree .
#= require_self

#= require turbolinks

ready = ->
  window.isMouseDown = false

  $('.tags').tagsinput
    trimValue: true,
    confirmKeys: [13,44,32,188,186] #  Enter, unknown, Space, Comma, CommaDot

  $('.tags-email').on 'beforeItemAdd', (event) ->
    email_rule = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
    event.cancel = !email_rule.test(event.item)

  $('.panel-scroll').perfectScrollbar
    wheelSpeed: 50
    minScrollbarLength: 20
    suppressScrollX: true

  $(document).mouseup ->
    window.isMouseDown = false

  $('.search-select').select2
    allowClear: true

  # turbolinks and ajax form hack
  $('form[data-remote="true"] [type="submit"]').on 'click', (e) ->
    e.preventDefault()
    $(@).parents('form').trigger('submit.rails')

  page = $('body').data('page')
  menu = $('li[data-menu~="' + page + '"]')

  if menu.length
    menu.addClass('active')
    menu.parents('li').addClass('open active')


$(document).on "ready page:load", ready

# Turbolinks spinner and another one for displaying in photo uploading boxes
$(document).on "page:fetch page:receive eventFormSent", ->
  triggerSpinner()

window.triggerSpinner = ->
  $("#spinner_placeholder").toggleClass "hidden"
  $("html").toggleClass "no-scroll"
  return

window.blockElemet = (el) ->
  el.block
    overlayCSS:
      backgroundColor: '#fff'
    message: $('#locker').html()
    css:
      border: 'none'
      color: '#333'
      background: 'none'
