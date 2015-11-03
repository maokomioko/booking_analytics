#= require_tree .
#= require_self

graphReady = ->
  $(document).on 'touchstart touchend touchcancel', ->
    alert 'this'
    return

  return unless $('body').data('page').match(/graph:hotels/)
  $dateSlider = $('#date-range-slider')
  if $dateSlider.length
    window.defaultDays =
      min: +moment().subtract(2, 'week').format("X")
      max: +moment().format("X")

    $dateSlider.ionRangeSlider
      type: 'double'
      min: +moment().subtract(3, 'month').format("X")
      max: +moment().add(3, 'month').format("X")
      from: defaultDays.min
      to: defaultDays.max
      force_edges: true
      step: 1
      grid: true
      grid_num: 1
      prettify: (num) ->
        moment(num, 'X').format 'LL'

    # $dateSlider.dateRangeSlider
    #   range:
    #     min:
    #       days: 7
    #     max:
    #       days: 93
    #   bounds:
    #     min: moment().subtract(3, 'month').toDate()
    #     max: moment().add(3, 'month').toDate()
    #   defaultValues:
    #     min: defaultDays.min.toDate()
    #     max: defaultDays.max.toDate()
    #   formatter: (val) -> moment(val).format('LL')

    # set date on load
    # $('#form_date_from').val(defaultDays.min.format('DD.MM.YYYY'))
    # $('#form_date_to').val(defaultDays.max.format('DD.MM.YYYY'))

    # $dateSlider.bind 'userValuesChanged', (e, data) ->
    #   $('#form_date_from').val(moment(data.values.min).format('DD.MM.YYYY'))
    #   $('#form_date_to').val(moment(data.values.max).format('DD.MM.YYYY'))

    # $('.graph-options-submit').on 'click', (e) ->
    #   blockElement($('#graph-container'))

$(document).on "ready page:load", graphReady
