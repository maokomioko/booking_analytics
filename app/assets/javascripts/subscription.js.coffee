class @Subscription
  constructor: ->
    @initTriggers()

  initTriggers: ->
    $('.modify_subscription').click ->
      highlightChanges($(@))
      setAmount()
      updateSignature()

  highlightChanges = (element) ->
    $(element).find('span').toggleClass('hidden')
    $(element).parents('tr').toggleClass('active')

  updateSignature = ->
    $.ajax
      url: "/payments/update_signature"
      method: 'POST'
      data: { amount: $('#price').val() }
      success: (data) ->
        console.log data
        $('#sign').val(data['signature'])

  setAmount = ->
    sum = 0

    $('.active').each ->
      sum += Number($(@).find('.price').text())

    $('#price').val(sum)
