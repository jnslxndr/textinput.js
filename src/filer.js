/*!
  Filer helps you to retrieve data from files, you select via a dialog
  ... but nice and styled
  
  licensed under the unlicense
  jens alexander ewald, 2011, ififelse.net
!*/
var File, FileReader;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __indexOf = Array.prototype.indexOf || function(item) {
  for (var i = 0, l = this.length; i < l; i++) {
    if (this[i] === item) return i;
  }
  return -1;
};
window.filersupport = false;
try {
  window.filersupport = (FileReader != null) && (File != null);
} catch (error) {
  FileReader = File = false;
}
$(function() {
  return $.fn.filer = function(callback, filetypes) {
    var input;
    this.addClass("filer");
    if (!window.filersupport) {
      this.addClass("unsupported");
      console.error("FILE OBJECTS NOT SUPPORTED");
      return this;
    }
    this.DEBUG = false;
    this.bind("selectstart", function(event) {
      return typeof event.preventDefault === "function" ? event.preventDefault() : void 0;
    });
    input = $('<input type="file" style="position:absolute; top: -999999px;" id="filerhelper">');
    input = $(input).appendTo($('body').remove('#filerhelper'));
    this.click(__bind(function(event) {
      $(this).removeClass('success loaded');
      input.click();
      return false;
    }, this));
    return input.change(__bind(function(event) {
      var file, reader, _ref;
      if (typeof event.preventDefault === "function") {
        event.preventDefault();
      }
      file = event.target.files[0];
      if (!file) {
        return false;
      }
      if (filetypes != null) {
        if (!(filetypes instanceof Array)) {
          filetypes = [filetypes];
        }
        if (_ref = file.type, __indexOf.call(filetypes, _ref) < 0) {
          return false;
        }
      }
      $(this).addClass("success");
      console.log(file);
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
        console.log(callback, callback.success);
        return typeof callback.success === "function" ? callback.success(event.target.result, file.name, suffix, istext) : void 0;
      }, this);
      return reader.readAsText(file);
    }, this));
  };
});