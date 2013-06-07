//= require jquery
//= require jquery_ujs
//= require_tree .

//= require bootstrap-datepicker

$(document).on("focus", "[data-behaviour~='datepicker']", function(e){
    $(this).datepicker({
    	"format": "yyyy-mm-dd",
    	language: "ru",
    	"weekStart": 1, 
    	"autoclose": true})
});