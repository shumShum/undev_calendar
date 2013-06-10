//= require jquery
//= require jquery_ujs
//= require_tree .

//= require bootstrap-datepicker
//= require bootstrap-timepicker

$(document).on("focus", "[data-behaviour~='datepicker']", function(e){
    $(this).datepicker({
    	"format": "yyyy-mm-dd",
    	language: "ru",
    	"weekStart": 1, 
    	"autoclose": true})
});

$(document).on("focus", "[data-behaviour~='timepicker']", function(e){ 
	$(this).timepicker().on('changeTime', function(ev) {
      alert('time has changed');
      });
});