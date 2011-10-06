/*!
  Dropper helps you to read dropped files and retrieve its text value
!*/
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
$(function() {
  var errorHandler;
  errorHandler = function(evt) {
    switch (evt.target.error.code) {
      case evt.target.error.NOT_FOUND_ERR:
        return alert("Datei konnte nicht gefunden werden.");
      case evt.target.error.NOT_READABLE_ERR:
        return alert("Datei kann nicht gelesen werden.");
      case evt.target.error.ABORT_ERR:
        return alert("Abgebrochen.");
      default:
        return alert("Ein unbekannter Fehler ist aufgetreten.");
    }
  };
  return $.fn.dropper = function(callback) {
    this.DEBUG = true;
    this.addClass("dropper");
    jQuery.event.props.push("dataTransfer");
    $(document).bind("dragover drop", function(event) {
      return typeof event.preventDefault === "function" ? event.preventDefault() : void 0;
    });
    this.bind("selectstart", function(event) {
      return typeof event.preventDefault === "function" ? event.preventDefault() : void 0;
    });
    this.removeClass("loaded success dragover dropped").bind("dragover", function(event) {
      if (typeof event.preventDefault === "function") {
        event.preventDefault();
      }
      event.stopPropagation();
      $(this).addClass("dragover").removeClass("dropped");
      return false;
    }).bind("mouseout dragend", function() {
      return $(this).removeClass("dragover dropped");
    });
    return this.bind("drop", __bind(function(event) {
      var file, reader;
      $(this).removeClass("dragover").addClass("dropped");
      event.stopPropagation();
      event.preventDefault();
      file = event.dataTransfer.files[0];
      reader = new TextFileReader();
      reader.bind(callback, {
        always: __bind(function(event) {
          return $(this).addClass(event.type);
        }, this)
      });
      return reader.read(file);
    }, this));
  };
});