$ ->
  $('#graph-container').empty()
  c3.generate
    bindto: '#graph-container'
    axis:
      x:
        type: 'timeseries'
        tick:
          format: '%Y-%m-%d'
    data:
      x: 'x'
      columns: <%= raw @data.merged.to_s %>
    grid:
      x:
        show: true
      y:
        show: true
