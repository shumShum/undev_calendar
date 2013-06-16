//= require jquery
//= require jquery_ujs

$(document).ready(function(e) {
  var source;
  var template;
  
  if (typeof($('#event_is_repeat')[0]) != "undefined") {
    if ($('#event_is_repeat')[0].checked === true) {
      $gen_def_check = $('#repeat_check').clone(true, true);
      source   = $("#repeat-type-template").html();
      template = Handlebars.compile(source);
      $('#repeat_check').append(template());

      if ($('#repeat_of')[0].value === "week") {
        $gen_def_type = $('#repeat_type').clone(true, true);
        source   = $("#repeat-week-template").html();
        template = Handlebars.compile(source);
        $('#repeat_type').append(template());
      }
      if ($('#repeat_of')[0].value === "month") {
        $gen_def_type = $('#repeat_type').clone(true, true);
        source   = $("#repeat-month-template").html();
        template = Handlebars.compile(source);
        $('#repeat_type').append(template());
      }

    }
  }

  $event = gon.event

});

$(function() {
  $('#repeat_event').on('click', '#event_is_repeat', function(e) {
    var source;
    var template;
    var gen = $('#repeat_check');
    var ch_box = $(this)[0];
    if (typeof($gen_def_check) == "undefined") {
      $gen_def_check = gen.clone(true, true);
    }
    if (ch_box.checked === true) {
      // $gen_def_check = gen.clone(true, true);
      source   = $("#repeat-type-template").html();
      template = Handlebars.compile(source);
      gen.append(template());

      $event.is_repeat = true;
      }
    else {
      gen.empty().append($gen_def_check.html());

      $event.is_repeat = false;
      }
  });
});

$(function() {
  $('#repeat_event').on('change', '#repeat_of', function(e) {
    var source;
    var template;
    var sel = $(this)[0];
    var gen = $('#repeat_type');
    if (typeof($gen_def_type) == "undefined") {
      $gen_def_type = gen.clone(true, true);
    }
    if (sel.value === 'week') {
      gen.empty().append($gen_def_type.html());
      source   = $("#repeat-week-template").html();
      template = Handlebars.compile(source);
      gen.append(template());

      $event.repeat_type = "week";
    }
    else {
      if (sel.value === 'month'){
        gen.empty().append($gen_def_type.html());
        source   = $("#repeat-month-template").html();
        template = Handlebars.compile(source);
        gen.append(template());

        $event.repeat_type = "month";
      }
      else {
        gen.empty().append($gen_def_type.html());
        $event.repeat_type = "";
      }
    }
  });
});

// $(function() {
//   $('#day_of_month').on('click', '.btn', function(e) {
//     gon.event.repeat_days = gon.event.repeat_days + ' ' + $('#new_number')[0].value
//     $('#repeat_days').empty().append(gon.event.repeat_days) 
//   });
// });

// $(function() {
// 	$('#commit_event').on('click', ".btn", function() {
// 		get_week_days();
// 		$.ajax({
// 	    url: '/',
// 	    type: 'PUT',
// 	    data: $event,
// 	    dataType: 'json'
// 	  });
// 	});
// });

function get_week_days(){
	var ch_box = $(this)[0];
  var days_str = "";
  var ch;
  $('[name=repeat_days]').each(function() {
    ch = $(this)[0];
    if (ch.checked === true) {
    	days_str = days_str + ch.value + ' ';
    }
   });
  $event.repeat_days = days_str;
}

// $(function() {
//   $('#repeat_event').on('click', '#repeat_days', function(e){
//     var ch_box = $(this)[0];
//     if (ch_box.checked === true) {
//       $.ajax({
//         url: 'new_repeat_day',
//         type: 'POST',
//         data: {day: ch_box.value},
//         dataType: 'json',
//         async: true,
//       });
//     }
//     else {
//       $.ajax({
//         url: 'del_repeat_day',
//         type: 'POST',
//         data: {day: ch_box.value},
//         dataType: 'json',
//         async: true,
//       });
//     }
//   });
// });