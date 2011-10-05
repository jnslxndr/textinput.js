$ ->
  $('#pastehere').paster (data) ->
    console.log "PASTER: ",data
  
  $('#drophere').dropper (data) ->
    error: (errro) ->
      console.log "FILER error ",error
    success: (data,name,suffix,istext) ->
      console.log "FILER loaded ",data.length,name,suffix,istext
  
  $('#filehere').filer
    error: (errro) ->
      console.log "FILER error ",error
    success: (data,name,suffix,istext) ->
      console.log "FILER loaded ",data.length,name,suffix,istext
  