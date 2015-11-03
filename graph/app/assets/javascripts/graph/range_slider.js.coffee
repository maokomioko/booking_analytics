class @RangeSlider
  constructor: ->
    if typeof(slider) != undefined
      @forceStopSlider()
    if $('body').data('page').match(/graph:hotels/)
      @initSlider()

  initSlider: ->
    dateSlider = $('#date-range-slider')

    if dateSlider.length
      defaultDays =
        min: moment().subtract(2, 'week')
        max: moment()

      dateSlider.ionRangeSlider
        type: 'double'
        min: +moment().subtract(3, 'month').format("X")
        max: +moment().add(3, 'month').format("X")
        from: +defaultDays.min.format("X")
        to: +defaultDays.max.format("X")
        force_edges: true
        step: 1
        grid: true
        grid_num: 1
        prettify: (num) ->
          moment(num, 'X').format 'LL'
        onUpdate: (data) ->
          $('#form_date_from').val(moment.unix(data.from).format('DD.MM.YYYY'))
          $('#form_date_to').val(moment.unix(data.to).format('DD.MM.YYYY'))

      $('#form_date_from').val(defaultDays.min.format('DD.MM.YYYY'))
      $('#form_date_to').val(defaultDays.max.format('DD.MM.YYYY'))

      $('.graph-options-submit').on 'click', (e) ->
        blockElement($('#graph-container'))

    window.slider = dateSlider.data("ionRangeSlider")

  forceStopSlider: ->

    timeout = null
    $(document).on 'mousemove', ->
      clearTimeout timeout
      timeout = setTimeout((->
        slider.update()
        return
      ), 300)
      return
