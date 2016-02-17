//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require ./vendors/bootstrap
//= require ./vendors/angular
//= require ./vendors/angular-bootstrap
//= require ./vendors/loading-bar
//= require ./vendors/notify
//= require ./vendors/angular_animate
//= require ./vendors/angular-file-upload
//= require ./vendors/bootbox
//= require ./vendors/moment
//= require ./vendors/full-calendar
//= require ./vendors/angular-datetime-picker
//= require ./vendors/angular-datetime-picker-template
//= require ./vendors/underscore
//= require ./organisations/base
//= require ./organisations/sign_up_controller
//= require ./organisations/organisation_admin_controller
//= require ./organisations/sign_in_controller
//= require ./organisations/aircrafts
//= require ./organisations/aircraft
//= require ./organisations/header_controller
//= require ./organisations/forum_topic_controller
//= require ./organisations/forum_topic_comments_controller
//= require ./organisations/settings
//= require ./organisations/operator
//= require ./organisations/aircrafts_service
//= require ./organisations/new_unavailability_controller
//= require ./organisations/aircraft_unavilabilities_controller

try {
    Turbolinks.enableProgressBar();
}catch(e) {
    console.log('ERROR: Turbolinks is not defined.')
}

$(document).on('ready page:load', function(){
    angular.bootstrap(document.body, ['organisations_app']);
});