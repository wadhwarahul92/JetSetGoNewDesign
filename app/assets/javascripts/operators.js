//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require ./vendors/bootstrap
//= require ./vendors/angular
//= require ./vendors/angular-bootstrap
//= require ./operators/base
//= require ./operators/welcome

$(document).on('ready page:load', function(){
    angular.bootstrap(document.body, ['operator_app'])
});