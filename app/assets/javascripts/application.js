//= require jquery
//= require ./vendors/moment
//= require ./vendors/angular
//= require ./vendors/angular-route
//= require ./vendors/angular-bootstrap
//= require ./vendors/angular_animate
//= require ./vendors/notify
//= require ./vendors/angular-file-upload
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
//= require ./application/aircraft_categories_service
//= require ./application/search_controller
//= require ./application/aircrafts_service
//= require ./application/contact_us_controller
//= require ./application/quotes_controller
//= require ./application/about_us_controller
//= require ./application/search_detail_controller
//= require ./application/jet_set_rescue_controller
//= require ./application/forget_password_controller
//= require ./application/jet_set_yatra_controller
//= require ./application/jet_set_yatra_enquiry_controller
//= require ./application/jet_set_wed_controller
//= require ./application/jet_set_wed_enquiry_controller
//= require ./application/jet_set_rescue_controller
//= require ./application/jet_set_rescue_enquiry_controller
//= require ./application/heli_set_go_controller
//= require ./application/heli_set_go_enquiry_controller
//= require ./application/profile_controller
//= require ./application/booked_jets_controller
//= require ./application/upcoming_journeys_controller
//= require ./application/past_journeys_controller
//= require ./application/enquired_jets_controller
//= require ./application/offers_controller
//= require ./application/media_controller
//= require ./application/passenger_details_controller
//= require ./application/detail_controller
//= require ./application/sell_empty_leg_controller
//= require ./application/requested_add_passenger_controller
//= require ./application/tmp_send_sms_controller
//= require ./application/our_fleet_controller
//= require ./application/helicopter_fleet_controller
//= require ./application/turboprop_controller
//= require ./vendors/date
//= require ./vendors/filter_slider
//= require ./services/base
//= require ./services/cost_break_ups_service
//= require ./services/customer_cost_break_ups_service
//= require ./vendors/owl-carousel/owl_carousel

$(document).on('ready page:load', function(){

    $(document).on('click', '.btn', function(){
        var _this = $(this);
        _this.addClass('hvr-push');
        setTimeout(function(){
            _this.removeClass('hvr-push');
        },300);
    });

});