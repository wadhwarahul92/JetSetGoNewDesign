//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree ./common
//= require_tree ./admin

try {
    Turbolinks.enableProgressBar();
}catch(e) {
    console.log('ERROR: Turbolinks is not defined.')
}
