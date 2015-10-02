class @Reservation
  constructor: ->
    @validateCheckout()
    @triggerSubmission()
    @reloadMap()

  validateCheckout: ->
    $(document).on 'change', '.calendar_daterange input', ->
      from_value = $('#reservation_check_in').val()
      to_value = $('#reservation_check_out').val()

      date_from = moment(from_value)
      date_to = moment(to_value)

      if date_from > date_to
        new_date = date_from.diff(date_to, 'days')
        date_to = date_to.add(new_date + 1, 'days').format('YYYY-MM-DD')

        $('#reservation_check_out').val(date_to)
        $('#reservation_check_out').trigger('change')

  triggerSubmission: ->
    $(document).on 'ajax:success', '#overbooking_form', ->
      $(document).trigger('ovbSubmitted')

  reloadMap: ->
    $(document).on 'ovbSubmitted', ->
      window.reloadMarkers()
