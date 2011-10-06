var TextFileReader;
var __slice = Array.prototype.slice, __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
TextFileReader = (function() {
  TextFileReader.prototype.callbacks = {
    loadstart: [],
    progress: [],
    load: [],
    abort: [],
    error: [],
    loadend: [],
    success: [],
    always: []
  };
  function TextFileReader(filereader) {
    var _ref;
    this.filereader = filereader;
    try {
      this.filereader = (_ref = this.filereader) != null ? _ref : new FileReader();
    } catch (error) {
      console.warn("");
    }
    this.supported;
  }
  TextFileReader.prototype.works = function() {
    return this.supported();
  };
  TextFileReader.prototype.supported = function() {
    try {
      return (typeof FileReader !== "undefined" && FileReader !== null) && (typeof File !== "undefined" && File !== null);
    } catch (error) {
      return false;
    }
  };
  TextFileReader.prototype.bind = function() {
    var callbacks;
    callbacks = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    console.log(callbacks);
    return this.add_cb.apply(this, callbacks);
  };
  TextFileReader.prototype.add_cb = function(cb) {
    var event, func, _base;
    for (event in cb) {
      func = cb[event];
      console.log(event, func, this.callbacks[event]);
      if (this.callbacks[event]) {
        if (typeof (_base = this.callbacks[event]).push === "function") {
          _base.push(func);
        }
      }
    }
    return console.log("added callback: ", cb, this.callbacks);
  };
  TextFileReader.prototype.read = function(file) {
    this.file = file;
    if (!this.supported()) {
      return false;
    }
    if (this.filereader == null) {
      this.filereader = new FileReader();
    }
    this.filereader.onloadstart = function(event) {
      $(this).addClass("loadstart");
      if (this.DEBUG) {
        console.log("onloadstart", event);
      }
      return typeof callback.start === "function" ? callback.start(event) : void 0;
    };
    this.filereader.onprogress = function(event) {
      $(this).addClass("loaded progress");
      if (this.DEBUG) {
        console.log("onprogress", event);
      }
      return typeof callback.progress === "function" ? callback.progress(event) : void 0;
    };
    this.filereader.onload = function(event) {
      $(this).addClass("loaded load");
      if (this.DEBUG) {
        console.log("onload", event);
      }
      return typeof callback.load === "function" ? callback.load(event) : void 0;
    };
    this.filereader.onabort = function(event) {
      $(this).addClass("loaded abort");
      if (this.DEBUG) {
        console.log("onabort", event);
      }
      return typeof callback.abort === "function" ? callback.abort(event) : void 0;
    };
    this.filereader.onerror = function(event) {
      $(this).addClass("loaded error");
      if (this.DEBUG) {
        console.log("onerror", event);
      }
      return typeof callback.error === "function" ? callback.error(event) : void 0;
    };
    return this.filereader.onloadend = __bind(function(event) {
      var istext, suffix;
      $(this).addClass("loaded success");
      if (this.DEBUG) {
        console.log("onloadend", event);
      }
      suffix = file.name.split(".").reverse()[0];
      istext = /text/i.test(file.type);
      return typeof callback.success === "function" ? callback.success(event.target.result, file.name, suffix, istext) : void 0;
    }, this);
  };
  return TextFileReader;
})();
window.TextFileReader = TextFileReader;