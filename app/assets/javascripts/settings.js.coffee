class @Settings
  constructor: ->
    @initUserRatingSlider()
    @toggleSearchBar()
    @roomsSubmit()
    @roomsAutoSave()
    @settingsSubmit()
    @tabHacks()

  initUserRatingSlider: ->
    $ratings_slider = $('#user-rating-slider')
    $ratings_slider.ionRangeSlider
      type: 'double'
      min: 0
      max: 100
      from: $('#user-rating-from').val()
      to: $('#user-rating-to').val()
      step: 1
      grid: true
      grid_num: 1
      prettify: (val) -> val / 10
      onUpdate: (data) ->
        $('#user-rating-from').val(data.from)
        $('#user-rating-to').val(data.to)

    window.slider = $ratings_slider.data("ionRangeSlider")

  toggleSearchBar: ->
    $link = $('.text_link')
    $link.on 'click', ->
      $(@).toggleClass('hidden')
      target = $(@).data('target')
      $(target).toggleClass('hidden')

  roomsSubmit: ->
    $form = $('.rooms-form')
    manual = ->
      $form.find('[name=manual]').val()

    $form.on 'submit.rails', ->
      if manual() == 'true'
        blockElement $(@).parents('.tab-pane')

    $form.on 'ajax:complete', ->
      $(@).parents('.tab-pane').unblock()

  roomsAutoSave: ->
    $form = $('.rooms-form')

    $form.find('input[type=text], select').bindWithDelay 'change', ->
      $manual = $form.find('[name=manual]')
      $manual.val('false')
      $form.trigger('submit.rails')
      $manual.val('true')
    , 1800

  settingsSubmit: ->
    $form = $('.settings-form')
    $select = $('.search-select')

    $select.on 'change', ->
      $form.trigger('submit.rails')

    $form.on 'submit.rails', ->
      blockElement $('.settings-form')

    $form.on 'ajax:complete', ->
      $('.settings-form').unblock()

  tabHacks: ->
    $('a[href="#competitors_tab"]').on 'shown.bs.tab', ->
      $(window).trigger('resize') # fix slider
      window.centerMap()
