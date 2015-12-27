//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require ./vendors/angular
//= require_tree ./common
//= require_tree ./jetsteals

//ENABLE TOOLTIP
$(document).on('mouseenter', '[data-toggle=tooltip]', function(){
    $(this).tooltip('show');
});
////////////////