//= require jquery
//= require best_in_place
//= require jquery_ujs
//= require best_in_place.jquery-ui
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
    $('#jetsteal_departure_airport_id,#jetsteal_arrival_airport_id,#aircraft_aircraft_type_id,#aircraft_operator_id,#jetsteal_aircraft_id,#watch_hour_airport_id,#handling_cost_grid_city_id,#aircraft_type_id,#city_id').select2();

    jQuery(".best_in_place").best_in_place();
});
/////////////////