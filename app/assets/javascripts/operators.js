//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require ./vendors/bootstrap
//= require ./vendors/angular
//= require ./vendors/angular-bootstrap
//= require ./vendors/loading-bar
//= require ./vendors/notify
//= require ./vendors/angular_animate
//= require ./operators/base
//= require ./operators/welcome
//= require ./operators/aircrafts
//= require ./operators/aircraft

try {
    Turbolinks.enableProgressBar();
}catch(e) {
    console.log('ERROR: Turbolinks is not defined.')
}

$(document).on('ready page:load', function(){
    angular.bootstrap(document.body, ['operator_app'])
});