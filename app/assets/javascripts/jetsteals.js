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
//= require ./vendors/lightbox2

//stick a div on top when window reaches it
function sticky_relocate(){
    var div_to_stick = $('#filter_bar');
    if(div_to_stick && div_to_stick.length > 0){
        var window_top = $(window).scrollTop();
        var sticky_placeholder = $('#sticky-placeholder');
        var div_top = $('#sticky-anchor').offset().top;
        if (window_top > div_top){
            div_to_stick.addClass('stick');
            sticky_placeholder.css('height', div_to_stick.height());
        }else{
            div_to_stick.removeClass('stick');
            sticky_placeholder.css('height', 0);
        }
    }
}
////////////////////////////////////////////

$(document).on('ready page:load', function(){

    $(document).foundation();

    sticky_relocate();

    $(window).on('scroll', function(){sticky_relocate()});

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
    });

    $('#checkout_seat').validate({
        first_name: {
            required: true
        },
        last_name: {
            required: true
        },
        phone: {
            required: true,
            digits: true
        },
        email: {
            required: true,
            email: true
        }
    });

    $('#checkout_jet').validate({
        first_name: {
            required: true
        },
        last_name: {
            required: true
        },
        phone: {
            required: true,
            digits: true
        },
        email: {
            required: true,
            email: true
        }
    });

});