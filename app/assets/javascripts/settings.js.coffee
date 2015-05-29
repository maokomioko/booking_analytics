class @Settings
  constructor: ->
    @initUserRatingSlider()
    @roomsSubmit()
    @roomsAutoSave()
    @settingsSubmit()

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

  roomsSubmit: ->
    $form = $('.rooms-form')
    manual = ->
      $form.find('[name=manual]').val()

    $form.on 'submit.rails', ->
      if manual() == 'true'
        blockElemet $(@).parents('.tab-pane')

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

    $form.on 'submit.rails', ->
      blockElemet $(@).parents('.tab-pane')

    $form.on 'ajax:complete', ->
      $(@).parents('.tab-pane').unblock()