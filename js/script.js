$(function() {
  $('#pastehere').paster(function(data) {
    return console.log("PASTER: ", data);
  });
  $('#drophere').dropper(function(data) {
    return {
      error: function(errro) {
        return console.log("FILER error ", error);
      },
      success: function(data, name, suffix, istext) {
        return console.log("FILER loaded ", data.length, name, suffix, istext);
      }
    };
  });
  return $('#filehere').filer({
    error: function(errro) {
      return console.log("FILER error ", error);
    },
    success: function(data, name, suffix, istext) {
      return console.log("FILER loaded ", data.length, name, suffix, istext);
    }
  });
});