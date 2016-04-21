//= require jquery
//= require ./vendors/moment
//= require ./vendors/angular
//= require ./vendors/angular-route
//= require ./vendors/angular-bootstrap
//= require ./vendors/angular_animate
//= require ./vendors/notify
//= require ./vendors/loading-bar
//= require ./vendors/bootstrap
//= require ./vendors/angular-datetime-picker
//= require ./vendors/angular-datetime-picker-template
//= require ./vendors/underscore
//= require ./vendors/angular-full-calendar
//= require ./vendors/angular-no-captcha
//= require ./vendors/easy_pie_chart
//= require ./application/base
//= require ./application/current_user_service
//= require ./application/header_controller
//= require ./application/sign_in_controller
//= require ./application/sign_up_controller
//= require ./application/index_controller
//= require ./application/airports_service
//= require ./application/search_controller
//= require ./application/aircrafts_service
//= require ./application/contact_us_controller
//= require ./application/quotes_controller
//= require ./application/about_us_controller

$(document).on('ready page:load', function(){

    $(document).on('click', '.btn', function(){
        var _this = $(this);
        _this.addClass('hvr-push');
        setTimeout(function(){
            _this.removeClass('hvr-push');
        },300);
    });

});