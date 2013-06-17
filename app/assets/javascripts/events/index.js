//= require jquery
//= require jquery_ujs

$(document).ready(function(e) {
	var type = gon.time_option;
	if (type === "day") {
		$('#day_option').css({"border-color" : "#922"});
	}
	if (type === "week") {
		$('#week_option').css({"border-color" : "#922"});
	}
	if (type === "month") {
		$('#month_option').css({"border-color" : "#889"});
	}
});