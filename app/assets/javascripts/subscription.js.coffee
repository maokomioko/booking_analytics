class @Subscription
  constructor: ->
    @initTriggers()

  initTriggers: ->
    $('.modify_subscription').click ->
      highlightChanges($(@))
      setAmount()
      if $('#subscriptions .active').length > 0
        updateSubscription($(@))
      else
        toggleWarning()

  highlightChanges = (element) ->
    $(element).find('span').toggleClass('hidden')
    $(element).parents('tr').toggleClass('active')

  updateSubscription = (element) ->
    $.ajax
      url: "/payments/modify_items"
      method: 'POST'
      data: {
        amount: $('#price').val(),
        item_name: $(element).data('item-name'),
        action_name: $(element).find('span.hidden').data('action')
      }
      success: (data) ->
        $('#sign').val(data['signature'])

  setAmount = ->
    sum = 0

    $('#subscriptions .active').each ->
      sum += Number($(@).find('.price').text())

    $('#price').val(sum)

  toggleWarning = ->
    $('#payment_button').toggleClass('hidden')
    $('#payment_button').siblings('p').toggleClass('hidden')
