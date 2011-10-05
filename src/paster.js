/*!
  Paster.js helps you with entering textual content via paste
  supports intentional strg/cmd + v only at the moment
!*/
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
$(function() {
  return $.fn.paster = function(callback) {
    jQuery.event.props.push("clipboardData");
    return this.each(__bind(function() {
      $(this).bind("selectstart", function(event) {
        return typeof event.preventDefault === "function" ? event.preventDefault() : void 0;
      });
      $(this).addClass("paster");
      $(this).find("textarea").remove();
      return $(this).click(function(event) {
        var dummy;
        $(this).find("textarea").remove();
        $(this).addClass("ready");
        dummy = $('<textarea style="position:absolute;left:-9999px;top:-99999em;width:0!important;height:0!important;"/>').appendTo($(this));
        dummy.val("");
        dummy.focus();
        dummy.one("blur", function(event) {
          $(this).closest('.paster').removeClass("ready");
          return $(this).remove();
        });
        return dummy.one("paste", function(event) {
          var clip, data, type, _ref, _ref2;
          $(this).closest('.paster').removeClass("ready");
          clip = (_ref = event.clipboardData) != null ? _ref : event.originalEvent.clipboardData;
          if (clip) {
            type = (_ref2 = clip.types) != null ? _ref2 : "Text";
            data = typeof clip.getData === "function" ? clip.getData(type) : void 0;
            if (typeof callback === "function") {
              callback(data, event);
            }
            return $(this).remove();
          } else {
            return $(this).one("change keyup", function(event) {
              if (typeof event.preventDefault === "function") {
                event.preventDefault();
              }
              data = $(this).val();
              if (typeof callback === "function") {
                callback(data, event);
              }
              return $(this).remove();
            });
          }
        });
      });
    }, this));
  };
});