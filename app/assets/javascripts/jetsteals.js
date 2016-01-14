//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree ./common
//= require ./vendors/angular
//= require ./vendors/jquery_validate
//= require ./vendors/lightbox
//= require_tree ./jetsteals
//= require bootstrap-datepicker

try {
    Turbolinks.enableProgressBar();
}catch(e) {
    console.log('ERROR: Turbolinks is not defined.')
}

//ENABLE TOOLTIP
$(document).on('mouseenter', '[data-toggle=tooltip]', function(){
    $(this).tooltip('show');
});
////////////////
//ENABLE SELECT2
$(document).on('ready page:load', function(){
    $('#departure_airport_id,#arrival_airport_id,#aircraft_type_id').select2();
});
////////////////
