#= require raphael
#= require morris
#= require moment
#= require moment/en-gb
#= require jQAllRangeSliders-min

$ ->
  $dateSlider = $('#date-range-slider')

  if $dateSlider.length
    window.defaultDays =
      min: moment().subtract(1, 'week')
      max: moment()

    $dateSlider.dateRangeSlider
      range:
        min:
          days: 7
        max:
          days: 93
      bounds:
        min: moment().subtract(3, 'month').toDate()
        max: moment().add(3, 'month').toDate()
      defaultValues:
        min: defaultDays.min.toDate()
        max: defaultDays.max.toDate()
      formatter: (val) -> moment(val).format('LL')

    # set date on load
    $('#form_date_from').val(defaultDays.min.format('DD.MM.YYYY'))
    $('#form_date_to').val(defaultDays.max.format('DD.MM.YYYY'))

    $dateSlider.bind 'userValuesChanged', (e, data) ->
      $('#form_date_from').val(moment(data.values.min).format('DD.MM.YYYY'))
      $('#form_date_to').val(moment(data.values.max).format('DD.MM.YYYY'))

  return