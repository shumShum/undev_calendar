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
        $event.repeat_days = ""
      }
      else {
        gen.empty().append($gen_def_type.html());
        $event.repeat_type = "";
      }
    }
  });
});

$(function() {
	$('#commit_event').on('click', ".btn", function() {
		if ($event.repeat_type === "month") {
      $('#new_number')[0].type = "text"
      $('#new_number')[0].value = gon.event.repeat_days;
    }
		
	});
});

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

function add_month_repeat(){
  var arr;
  var value = $('#new_number')[0].value
  if (gon.event.repeat_days === "") {
    arr = [];
  }
  else {
    arr = gon.event.repeat_days.split(" ");
  }
  
  if ((parseInt(value, 10) > 0) && (parseInt(value, 10) < 32)) {
    if (arr.indexOf(value) === -1) {
      arr.push(value);
      gon.event.repeat_days = arr.join(" ");
      $('#repeat_days').empty().append(arr.join(", "));
      $('#del_number').append($("<option></option>").text(value));
    }
  }
}

function del_month_repeat() {
  var arr;
  var value = $('#del_number')[0].value;
  arr = gon.event.repeat_days.split(" ");
  var index = arr.indexOf(value);
  if (index > -1) {
    arr.splice(index, 1);
    gon.event.repeat_days = arr.join(" ");
    $('#repeat_days').empty().append(arr.join(", "));
  }
  // $('#del_number')[0].value = -1;
  $('#del_number').empty();
  for (var i = 0; i < arr.length; i++) {
     $('#del_number').append($("<option></option>").text(arr[i]));
  }
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