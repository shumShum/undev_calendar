//= require jquery
//= require jquery_ujs

// отрисовка нужного календаря в зависимости от параметра time_option;
// выделение типа календаря на панели навигации
$(document).ready(function(e) {
	var type = gon.time_option;
	var source;
  var template_nav;
	if (type === "day") {
		$('#day_option').css({"border-color" : "#889"});

		source   = $("#day-nav-template").html();
    template_nav = Handlebars.compile(source);

    source   = $("#day-cal-template").html();
    template_cal= Handlebars.compile(source);
	}
	if (type === "week") {
		$('#week_option').css({"border-color" : "#889"});

		source   = $("#week-nav-template").html();
    template_nav = Handlebars.compile(source);

    source   = $("#week-cal-template").html();
    template_cal = Handlebars.compile(source);
	}
	if (type === "month") {
		$('#month_option').css({"border-color" : "#889"});

		source   = $("#month-nav-template").html();
    template_nav = Handlebars.compile(source);

    source   = $("#month-cal-template").html();
    template_cal = Handlebars.compile(source);
	}
	$('#navigation').append(template_nav());
	$('#calendar').append(template_cal());
});
