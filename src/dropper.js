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
    this.bind("dragover", function(event) {
      if (typeof event.preventDefault === "function") {
        event.preventDefault();
      }
      event.stopPropagation();
      $(this).addClass("dragover").removeClass("dropped");
      return false;
    }).bind("mouseout dragend", function() {
      return $(this).removeClass("dragover,dropped");
    });
    return this.bind("drop", __bind(function(event) {
      var file, reader;
      $(this).removeClass("dragover").addClass("dropped");
      event.stopPropagation();
      event.preventDefault();
      console.log(event);
      file = event.dataTransfer.files[0];
      console.log(file, callback);
      if (this.DEBUG) {
        try {
          console.log("" + file.name + ", " + file.type + " (" + file.size + ", " + (file.lastModifiedDate.toLocaleDateString()) + ")");
        } catch (error) {
          console.log("ups", "" + file.name + ", " + file.type + " (" + file.size + ")");
        }
      }
      reader = new FileReader();
      reader.onloadstart = function(event) {
        if (this.DEBUG) {
          console.log("onloadstart", event);
        }
        return typeof callback.start === "function" ? callback.start(event) : void 0;
      };
      reader.onprogress = function(event) {
        if (this.DEBUG) {
          console.log("onprogress", event);
        }
        return typeof callback.progress === "function" ? callback.progress(event) : void 0;
      };
      reader.onload = function(event) {
        if (this.DEBUG) {
          console.log("onload", event);
        }
        return typeof callback.load === "function" ? callback.load(event) : void 0;
      };
      reader.onabort = function(event) {
        if (this.DEBUG) {
          console.log("onabort", event);
        }
        return typeof callback.abort === "function" ? callback.abort(event) : void 0;
      };
      reader.onerror = function(event) {
        if (this.DEBUG) {
          console.log("onerror", event);
        }
        return typeof callback.error === "function" ? callback.error(event) : void 0;
      };
      reader.onloadend = __bind(function(event) {
        var istext, suffix;
        $(this).addClass("loaded");
        if (this.DEBUG) {
          console.log("onloadend", event);
        }
        suffix = file.name.split(".").reverse()[0];
        istext = /text/i.test(file.type);
        return typeof callback.success === "function" ? callback.success(event.target.result, file.name, suffix, istext) : void 0;
      }, this);
      return reader.readAsText(file);
    }, this));
  };
});