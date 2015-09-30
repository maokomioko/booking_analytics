class @Settings
  constructor: ->
    @initUserRatingSlider()
    @toggleSearchBar()
    @roomsSubmit()
    @roomsAutoSave()
    @settingsSubmit()
    @tabHacks()

  initUserRatingSlider: ->
    $slider = $('#user-rating-slider')

    $slider.rangeSlider
      bounds:
        min: 0
        max: 100
      defaultValues:
        min: $('#user-rating-from').val()
        max: $('#user-rating-to').val()
      step: 1
      formatter: (val) -> val / 10

    $slider.bind 'userValuesChanged', (e, data) ->
      $('#user-rating-from').val(data.values.min)
      $('#user-rating-to').val(data.values.max)
      $('.settings-form').trigger('submit.rails')

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
