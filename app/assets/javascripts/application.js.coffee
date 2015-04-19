#= require jquery2
#= require turbolinks

#= require jquery_ujs
#= require jquery-ui
#= require jquery.remotipart

#= require bootstrap-sprockets
#= require bootstrap-hover-dropdown.min
#= require bootstrap-tagsinput
#= require bootstrap-fileupload.min

#= require jquery.blockUI

#= require jquery.mousewheel
#= require jquery.cookie
#= require select2

#= require jquery.validate

#= require_tree ../../../vendor/assets/javascripts/
#= require_tree .
#= require_self

ready = ->
  window.isMouseDown = false

  $('.tags').tagsinput
    trimValue: true,
    confirmKeys: [13,44,32,188,186] #  Enter, unknown, Space, Comma, CommaDot

  $('.tags').on 'beforeItemAdd', (event) ->
    email_rule = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
    event.cancel = !email_rule.test(event.item)

  $('.panel-scroll').perfectScrollbar
    wheelSpeed: 50
    minScrollbarLength: 20
    suppressScrollX: true

  $(document).mouseup ->
    window.isMouseDown = false

  if $('.search-select').length
    $('.search-select').select2
      allowClear: true

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
