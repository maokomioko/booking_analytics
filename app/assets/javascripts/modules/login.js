var Login = function () {

    var runSetDefaultValidation = function () {
        $.validator.setDefaults({
            errorElement: "span", // contain the error msg in a small tag
            errorClass: 'help-block',
            errorPlacement: function (error, element) { // render error placement for each input type
                if (element.attr("type") == "radio" || element.attr("type") == "checkbox") { // for chosen elements, need to insert the error after the chosen container
                    error.insertAfter($(element).closest('.form-group').children('div').children().last());
                } else if (element.attr("name") == "card_expiry_mm" || element.attr("name") == "card_expiry_yyyy") {
                    error.appendTo($(element).closest('.form-group').children('div'));
                } else {
                    error.insertAfter(element);
                    // for other inputs, just perform default behavior
                }
            },
            ignore: ':hidden',
            highlight: function (element) {
                $(element).closest('.help-block').removeClass('valid');
                // display OK icon
                $(element).closest('.form-group').removeClass('has-success').addClass('has-error').find('.symbol').removeClass('ok').addClass('required');
                // add the Bootstrap error class to the control group
            },
            unhighlight: function (element) { // revert the change done by hightlight
                $(element).closest('.form-group').removeClass('has-error');
                // set error class to the control group
            },
            success: function (label, element) {
                label.addClass('help-block valid');
                // mark the current input as valid and display OK icon
                $(element).closest('.form-group').removeClass('has-error');
            },
            highlight: function (element) {
                $(element).closest('.help-block').removeClass('valid');
                // display OK icon
                $(element).closest('.form-group').addClass('has-error');
                // add the Bootstrap error class to the control group
            },
            unhighlight: function (element) { // revert the change done by hightlight
                $(element).closest('.form-group').removeClass('has-error');
                // set error class to the control group
            }
        });
    };
    var runLoginValidator = function () {
        var form = $('.form-login');
        var errorHandler = $('.errorHandler', form);
        form.validate({
            rules: {
                'user[email]': {
                    minlength: 2,
                    required: true
                },
                'user[password]': {
                    minlength: 6,
                    required: true
                }
            },
            submitHandler: function (form) {
                errorHandler.hide();
                form.submit();
            },
            invalidHandler: function (event, validator) { //display error alert on form submit
                errorHandler.show();
            }
        });
    };
    var runForgotValidator = function () {
        var form2 = $('.form-forgot');
        var errorHandler2 = $('.errorHandler', form2);
        form2.validate({
            rules: {
                'user[email]': {
                    required: true
                }
            },
            submitHandler: function (form) {
                errorHandler2.hide();
                form2.submit();
            },
            invalidHandler: function (event, validator) { //display error alert on form submit
                errorHandler2.show();
            }
        });
    };
    var runRegisterValidator = function () {
        var form3 = $('.form-register');
        var errorHandler3 = $('.errorHandler', form3);
        form3.validate({
            rules: {
                'user[email]': {
                    required: true
                },
                'user[password]': {
                    minlength: 6,
                    required: true
                },
                'user[password_confirmation]': {
                    required: true,
                    minlength: 5,
                    equalTo: "#user_password"
                },
                agree: {
                    minlength: 1,
                    required: true
                }
            },
            submitHandler: function (form) {
                errorHandler3.hide();
                form3.submit();
            },
            invalidHandler: function (event, validator) { //display error alert on form submit
                errorHandler3.show();
            }
        });
    };
    
    //function to return the querystring parameter with a given name.
	var getParameterByName = function(name) {
		name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), results = regex.exec(location.search);
		return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	};
    
    
    return {
        //main function to initiate template pages
        init: function () {
            runSetDefaultValidation();
            runLoginValidator();
            runForgotValidator();
            runRegisterValidator();
        }
    };
}();