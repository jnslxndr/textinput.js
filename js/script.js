(function() {
  $(function() {
    var showdata;
    showdata = function(data, name, suffix, istext) {
      return console.log("FILER loaded ", name, suffix, istext, {
        "data": data
      });
    };
    $('#pastehere').paster(function(data) {
      return console.log("PASTER: ", data);
    });
    $('.droppit').dropper({
      error: function(error) {
        return console.log("FILER error ", error);
      },
      success: showdata
    });
    return $('#filehere').filer({
      error: function(error) {
        return console.log("FILER error ", error);
      },
      success: showdata
    });
  });
}).call(this);
