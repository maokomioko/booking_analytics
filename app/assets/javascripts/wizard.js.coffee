class @Wizard
  constructor: ->
    @initSelect2HotelSearch()
    @step4RoomsSubmit()
    @step4RoomsAutoSave()
    @step5Finish()

  initSelect2HotelSearch: ->
    $select = $('#search_hotel')

    return unless $select.length

    $select.select2
      multiple: false
      containerCss:
        width: '100%'
      ajax:
        url: $select.data('url')
        dataType: 'json'
        quietMillis: 250
        data: (term, page) -> { q: term }
        results: (data, page) ->
          { results: data }
      initSelection: (element, callback) ->
        id = $(element).val()
        if id != ''
          $.ajax
            url: $select.data('hotelUrl') + id
            success: (data) -> callback(data)

    return

  step4RoomsSubmit: ->
    $form = $('.rooms-form')
    $finishForm = $('.step4-finish-form')
    manual = ->
      $form.find('[name=manual]').val()

    $form.on 'submit.rails', ->
      if manual() == 'true'
        blockElemet $(@).parents('.container')

    $form.on 'ajax:complete', ->
      $(@).parents('.container').unblock()

    $form.on 'ajax:success', ->
      if manual() == 'true'
        $finishForm.trigger('submit.rails')

    $finishForm.on 'submit.rails', ->
      blockElemet $form.parents('.container')

    $finishForm.on 'ajax:complete', ->
      $form.parents('.container').unblock()

  step4RoomsAutoSave: ->
    $form = $('.rooms-form')

    $form.find('input[type=text], select').bindWithDelay 'change', ->
      $manual = $form.find('[name=manual]')
      $manual.val('false')
      $form.trigger('submit.rails')
      $manual.val('true')
    , 1300

  step5Finish: ->
    $finishForm = $('.step5-finish-form')

    $finishForm.on 'submit.rails', -> triggerSpinner()
    $finishForm.on 'ajax:complete', -> triggerSpinner()