#= require jquery2
#= require jquery_ujs

#= require underscore
#= require gmaps/google

#= require jquery-ui/datepicker

#= require jquery.remotipart

#= require bootstrap/alert
#= require bootstrap/collapse
#= require bootstrap/dropdown
#= require bootstrap/modal
#= require bootstrap/tab
#= require bootstrap/tooltip
#= require bootstrap/transition

#= require bootstrap-hover-dropdown.min
#= require bootstrap-tagsinput

#= require jquery.blockUI

#= require jquery.cookie
#= require select2

#= require jquery.validate

#= require inputmask
#= require jquery.inputmask
#= require inputmask.extensions
#= require inputmask.phone.extensions

#= require graph/application

#= require_tree ../../../vendor/assets/javascripts/
#= require js/jquery.icheck
#= require google-analytics-turbolinks
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

  attachICheck()

  $('body').mouseup ->
    window.isMouseDown = false

  $('.search-select').select2
    allowClear: true

  attachSelectPicker()
  attachCalendar()

  # turbolinks and ajax form hack
  $('form[data-remote="true"] [type="submit"]').on 'click', (e) ->
    e.preventDefault()
    $(@).parents('form').trigger('submit.rails')

attachSelectPicker = ->
  $('.selectpicker').selectpicker()

attachCalendar = ->
  $('.calendar_daterange input').datepicker
    dateFormat: 'yy-mm-dd'
    inline: true
    showOtherMonths: true

attachICheck = ->
   $('input.i_check').iCheck
    checkboxClass: 'icheckbox_flat-blue'
    radioClass: 'iradio_flat-blue'

$(document).on "ready page:load", ready
$(document).ajaxComplete ->
  attachSelectPicker()
  attachCalendar()
  attachICheck()

# Turbolinks spinner and another one for displaying in photo uploading boxes
$(document).on "page:fetch page:receive eventFormSent", ->
  triggerSpinner()

window.scrollElement = (element, i, margin) ->
  offset = $(element)[i].offsetTop - margin
  $("html, body").stop().animate {scrollTop: offset}, '600', 'swing'

window.triggerSpinner = ->
  $("#spinner_placeholder").toggleClass "hidden"
  $("html").toggleClass "no-scroll"
  return

window.blockElement = (el) ->
  el.block
    overlayCSS:
      backgroundColor: '#fff'
    message: $('#locker').html()
    css:
      border: 'none'
      color: '#333'
      background: 'none'

window.blockRowElement = (row) ->
  row.data('html', row.html())
  height  = row.height()
  colspan = row.find('td').length
  row.html("<td colspan='#{colspan}'></td>").find('td').css('height', height)
  blockElement(row.find('td'))

window.unblockRowElement = (row) ->
  row.find('td').unblock()
  row.html(row.data('html'))

window.removeRow = (row) ->
  row.find('td').contents().wrap("<div class='tdrow' />")
  row.find('.tdrow').slideUp '200', ->
    row.empty().remove()
