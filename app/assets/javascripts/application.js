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

// $(document).on("focus", "[data-behaviour~='timepicker']", function(e){ 
// 	$(this).timepicker();
// });

// $('.timepicker').timepicker()

(function( $ ){

  var methods = {
    init : function( options ) { 
      if($(".timepicker-popup").length==0){
        var hours           = 23;
        var minutes         = 59;
        var seperator       = ":";
        var popup           = $("<div>");
        var table           = $("<table>");
        var tableHour       = $("<td>");
        var tableMinute     = $("<td>");
        var tableSeperator  = $("<td>");
        var hour            = $("<select>");
        var minute          = $("<select>");
        for(h=0; h<=hours; h++){
          h = (h < 10) ? ("0" + h) : h;
          var rowHour = $("<option>");
          rowHour
            .attr("value", h)
            .text(h)
          ;
          hour.append(rowHour);
        }
        for(m=0; m<=minutes; m++){
          m = (m < 10) ? ("0" + m) : m;
          var rowMinute = $("<option>");
          rowMinute
            .attr("value", m)
            .text(m)
          ;
          minute.append(rowMinute);
        }
        hour
          .addClass("timepicker-popup-hour")
        ;
        minute
          .addClass("timepicker-popup-minute")
        ;
        tableHour
          .append(hour)
        ;
        tableSeperator
          .text(seperator)
        ;
        tableMinute
          .append(minute)
        ;
        table
          .append(tableHour)
          .append(tableSeperator)
          .append(tableMinute)
        ;
        popup
          .addClass("timepicker-popup")
          .addClass("dropdown-menu")
          .css("display", "block")
          .append(table)
          .hide()
        ;
        $("body").append(popup);
      }
      return this.each(function(){
        var thisOffset = $(this).offset();
        var thisElement = this;
        $(this).bind("focus", function(){
          $(".timepicker-popup-hour, .timepicker-popup-minute").val("00");
          if($(this).val()!=""){
            var inputTime = $(this).val();
            var splitTime = inputTime.split(":");
            if(splitTime.length==2){
              $(".timepicker-popup-hour").val(splitTime[0]);
              $(".timepicker-popup-minute").val(splitTime[1]);
            }
          }
          var timePickerPopup = $(".timepicker-popup");
          timePickerPopup
            .css("position", "absolute")
            .css("left", thisOffset.left + "px")
            .css("top", thisOffset.top + $(this).outerHeight(true) + "px")
            .data("caller", this)
            .show()
          ;
        });
        $(document).on('mousedown', function (e) {
          if ($(e.target).closest('.timepicker-popup').length == 0) {
            var caller = $(".timepicker-popup").data("caller");
            $(caller).val($(".timepicker-popup-hour").val() + seperator + $(".timepicker-popup-minute").val());
            $(".timepicker-popup").hide();
          }
        });

      });
    }
  };
  $.fn.timepicker = function( method ) {
    if ( methods[method] ) {
      return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
      return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.timepicker' );
    }
  };

})( jQuery );