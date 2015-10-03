$ ->
  $('#graph-container').empty()
  c3.generate
    bindto: '#graph-container'
    axis:
      x:
        label:
          text: 'Dates'
          position: 'outer-middle'
        type: 'timeseries'
        tick:
          format: '%Y-%m-%d'
      y:
        label:
          text: 'Prices (EUR)'
          position: 'outer-middle'
    data:
      x: 'x'
      columns: <%= raw @data.merged.to_s %>
    grid:
      x:
        show: true
      y:
        show: true
