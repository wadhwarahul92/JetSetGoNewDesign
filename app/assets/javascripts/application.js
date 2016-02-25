//= require jquery
//= require jquery_ujs
//= require ./vendors/angular
//= require ./vendors/angular-bootstrap
//= require ./vendors/notify
//= require ./vendors/loading-bar
//= require ./vendors/bootstrap
//= require ./application/base
//= require ./application/current_user_service
//= require ./application/header_controller
//= require ./application/sign_in_controller

$(document).on('ready page:load', function(){

    $(document).on('click', '.btn', function(){
        var _this = $(this);
        _this.addClass('hvr-push');
        setTimeout(function(){
            _this.removeClass('hvr-push');
        },300);
    });

});