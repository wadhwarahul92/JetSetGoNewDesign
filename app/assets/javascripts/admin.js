//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require ./vendors/angular
//= require ./vendors/bootstrap
//= require ./vendors/select2
//= require_tree ./admin

try {
    Turbolinks.enableProgressBar();
}catch(e) {
    console.log('ERROR: Turbolinks is not defined.')
}


//ENABLE TOOLTIPS
$(document).on('ready page:load', function(){
    $('[data-toggle=tooltip]').tooltip();
    $('#jetsteal_departure_airport_id,#jetsteal_arrival_airport_id,#aircraft_aircraft_type_id,#aircraft_operator_id,#jetsteal_aircraft_id,#watch_hour_airport_id,#handling_cost_grid_airport_id,#handling_cost_grid_aircraft_id').select2();
});
/////////////////