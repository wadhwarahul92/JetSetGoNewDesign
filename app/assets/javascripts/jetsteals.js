//= require jquery
//= require jquery_ujs
//= require ./vendors/angular
//= require_tree ./jetsteals
//= require turbolinks
//= require foundation
//= require ./vendors/foundation-datepicker
//= require ./vendors/underscore
//= require ./vendors/loading-bar
//= require ./vendors/select2.js
//= require ./vendors/jquery_validate

$(document).on('ready page:load', function(){

    $(document).foundation();

    if(window.localStorage['visited_jetsteals']){
        //do nothing
        //user has visited jetsteal before
    }else{
        $('#info_button')[0].click();
        window.localStorage['visited_jetsteals'] = true
    }

    $('.dp').fdatepicker({
        format: 'd M yyyy'
    });

    var a = $('#error_modal');
    if(a.length > 0){
        a.foundation('open');
    }

    $('.airports').select2({dropdownAutoWidth : true});

    $('#new_jetsteal_subscription').validate({
        jetsteal_subscription_name: {
            required: true
        },
        jetsteal_subscription_phone: {
            required: true,
            digits: true,
            minlength: 10,
            maxlength: 10
        },
        jetsteal_subscription_email: {
            required: true,
            email: true
        }
    })

});