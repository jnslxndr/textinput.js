var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
$(function() {
  return $.fn.dropper = function(callback) {
    return this.each(__bind(function() {
      $(this).bind("selectstart", function(event) {
        return typeof event.preventDefault === "function" ? event.preventDefault() : void 0;
      });
      $(this).addClass("dropper");
      return console.log("drops....");
    }, this));
  };
});