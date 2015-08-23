class @Settings
  constructor: ->
    @initUserRatingSlider()
    @roomsSubmit()
    @roomsAutoSave()
    @settingsSubmit()
    @rankingSubmit()
    @relatedPartnersUpdate()
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

    $form.on 'submit.rails', ->
      blockElement $(@).parents('.tab-pane')

    $form.on 'ajax:complete', ->
      $(@).parents('.tab-pane').unblock()

  rankingSubmit: ->
    $form = $('.room-settings-form')

    $form.on 'submit.rails', ->
      blockElement $(@).parents('.tab-pane')

    $form.on 'ajax:complete', ->
      $(@).parents('.tab-pane').unblock()

  relatedPartnersUpdate: ->
    $(document).on 'ajax:success', '.bulk-overbooking', ->
      $(@).parent().find('.bulk-overbooking.hidden').removeClass('hidden')
      $(@).addClass('hidden')

  tabHacks: ->
    $('a[href="#competitors_tab"]').on 'shown.bs.tab', ->
      $(window).trigger('resize') # fix slider
      google.maps.event.trigger map.getMap(), 'resize' # fix Gmap
      map.getMap().setZoom(16)
      map.getMap().setCenter(new google.maps.LatLng(gon.hotel.lat, gon.hotel.lng))
