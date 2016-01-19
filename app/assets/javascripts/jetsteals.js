//= require jquery
//= require jquery_ujs
//= require ./vendors/angular
//= require_tree ./jetsteals
//= require turbolinks
//= require foundation

$(document).on('ready page:load', function(){
    $(document).foundation();

    if(window.localStorage['visited_jetsteals']){

    }else{
        $('#info_button')[0].click();
        window.localStorage['visited_jetsteals'] = true
    }

});