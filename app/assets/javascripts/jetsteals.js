//= require jquery
//= require jquery_ujs
//= require ./vendors/angular
//= require_tree ./jetsteals
//= require turbolinks
//= require foundation
//= require ./vendors/foundation-datepicker
//= require ./vendors/underscore
//= require ./vendors/loading-bar

$(document).on('ready page:load', function(){
    $(document).foundation();

    if(window.localStorage['visited_jetsteals']){

    }else{
        $('#info_button')[0].click();
        window.localStorage['visited_jetsteals'] = true
    }

    $('.dp').fdatepicker({
        format: 'd M yyyy'
    });
});