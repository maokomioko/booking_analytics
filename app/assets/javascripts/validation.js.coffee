class @Validation
  constructor: ->
    @defaultSettings()
    @validationInit()

  validationInit: ->
    form = $('form')
    errorHandler = $('.errorHandler', form)

    $.validator.addClassRules
      with_validation:
        required: true
      number_validation:
        required: true
        minlength: 1
        customnumeric: true
      text_validation:
        required: true
        minlength: 4
      password_validation:
        required: true
        minlength: 8
      password_confirmation_validation:
        required: true
        minlength: 8
        equalTo: '.password_origin'

    form.validate
      submitHandler: (form) ->
        errorHandler.hide()
        form.submit()

      invalidHandler: (event, validator) ->
        errorHandler.show()

  defaultSettings: ->
    $.validator.setDefaults
      errorElement: 'span'
      errorClass: 'help-block'
      errorPlacement: (error, element) ->
        if element.attr('type') == 'radio' or element.attr('type') == 'checkbox'
          error.insertAfter $(element).closest('.form-group').children('div').children().last()
        else if element.attr('name') == 'card_expiry_mm' or element.attr('name') == 'card_expiry_yyyy'
          error.appendTo $(element).closest('.form-group').children('div')
        else
          error.insertAfter element
      ignore: ':hidden'

      highlight: (element) ->
        $(element).closest('.help-block').removeClass 'valid'
        $(element).closest('.form-group').removeClass('has-success').addClass('has-error').find('.symbol').removeClass('ok').addClass 'required'

      unhighlight: (element) ->
        $(element).closest('.form-group').removeClass 'has-error'

      success: (label, element) ->
        label.addClass 'help-block valid'
        $(element).closest('.form-group').removeClass 'has-error'

      highlight: (element) ->
        $(element).closest('.help-block').removeClass 'valid'
        $(element).closest('.form-group').addClass 'has-error'

      unhighlight: (element) ->
        $(element).closest('.form-group').removeClass 'has-error'
