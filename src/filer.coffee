window.filersupport = false
try
  window.filersupport = FileReader? and File?
catch error
  FileReader = File = false


$ ->
  
  $.fn.filer = (callback,filetypes) ->
    @addClass "filer"
    
    unless window.filersupport
      @addClass "unsupported"
      console.error "FILE OBJECTS NOT SUPPORTED"
      return @
    
    @DEBUG = false
    
    @each =>
      $(@).bind "selectstart", (event) -> event.preventDefault?()
      input = $('<input type="file" style="position:absolute; top: -999999px;" id="filerhelper">')
      input = $(input).appendTo($('body').remove('#filerhelper'))
      $(@).click (event) =>
        $(@).removeClass('success loaded')
        input.click()
        return false
      
      # ===================================
      # = This is where the magic happens =
      # ===================================
      input.change (event) =>
        [file,] = event.target.files
        return false unless file
        
        # = do some type checking
        if filetypes?
          filetypes = [filetypes] if not (filetypes instanceof Array)
          return false unless file.type in filetypes
        
        # = we are lucky and can process
        $(@).addClass("success")
        
        if @DEBUG
          try
            console.log "#{file.name}, #{file.type} (#{file.size}, #{file.lastModifiedDate.toLocaleDateString()})"
          catch error
            console.log "ups", "#{file.name}, #{file.type} (#{file.size})"
        
        # ======================================================
        # = Read the file and call callback with text or bytes =
        # ======================================================
        reader = new FileReader()
        reader.onloadstart = (event) ->
          console.log "onloadstart",event if @DEBUG
          callback.start?(event)
        reader.onprogress = (event) ->
          console.log "onprogress", event if @DEBUG
          callback.progress?(event)
        reader.onload = (event) ->
          console.log "onload",event if @DEBUG
          callback.load?(event)
        reader.onabort = (event) ->
          console.log "onabort",event if @DEBUG
          callback.abort?(event)
        reader.onerror = (event) ->
          console.log "onerror",event if @DEBUG
          callback.error?(event)
        reader.onloadend = (event) =>
          $(@).addClass("loaded")
          console.log "onloadend",event if @DEBUG
          [suffix,] = file.name.split(".").reverse()
          istext = /text/i.test file.type
          callback.success?(event.target.result,file.name,suffix,istext)
        
        # Start to read:
        reader.readAsText file
        
        