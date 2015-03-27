#= require bootstrap-tagsinput

$ ->
  $('#user_email').tagsinput
    trimValue: true,
    confirmKeys: [13,44,32,188,186] #  Enter, unknown, Space, Comma, CommaDot

  $('#user_email').on 'beforeItemAdd', (event) ->
    email_rule = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/i
    event.cancel = !email_rule.test(event.item)
