###!
  A simple wrapper class to read File/Blob objects directly as text
  
  licensed under the unlicense
  jens alexander ewald, 2011, ififelse.net
!###

# =====================================================================
# = Native objects can not be extended in coffee script, due to apply =
# =====================================================================
class window.TextFileReader
  callbacks: {}
  constructor: (@DEBUG) ->
    return false unless TextFileReader.works?
    
    # intstantiate the callbacks
    @callbacks = 
      loadstart: []
      progress:  []
      load:      []
      abort:     []
      error:     []
      loadend:   []
      # extra events hooked to internal
      success:   []
      always:    []
    
    @mimes = ["text/plain","text"]
    @encoding = "utf-8" # could also be null, defaults to utf-8
    @supported()
  
  setDebug: (@DEBUG) ->
  enableDebug: () -> @setDebug(true)
  enableDebug: () -> @setDebug(false)
  
  supported: () ->
    try
      FileReader? and File?
    catch error
      false

  bind: (callbacks...) ->
    @add_cb cb for cb in callbacks

  add_cb: (cb) ->
    for event,func of cb
      @callbacks[event].push?(func) if @callbacks[event]?
  
  setEncoding: (@encoding) ->
  setAllowedFileTypes: (mimes...) ->
    @mimes = mimes ? @mimes
  addAllowedFileTypes: (mimes...) ->
    return unless mimes?
    @mimes.push mime for mime in mimes
  
  read: (@file,encoding) ->
    @encoding = encoding ? @enconding
    return false if not @supported()
    filereader = new FileReader()
    
    supported_mimes = []
    for mime in @mimes
      r = new RegExp(mime,"i")
      supported_mimes.push r.test @file.type
    
    console?.log @mimes,supported_mimes if @DEBUG
    
    # unless /text/i.test @file.type
    unless true in supported_mimes
      eevent = 
        type: "error"
        code: TextFileReader.ERRORS.MIME_TYPE_NOT_SUPPORTED
        data: "Filetype not allowed"
        giventype: @file.type
        target: @
      cb?(eevent) for cb in @callbacks.error if @callbacks.error?
      return false
      
    # TODO Refactor with generic method and static array of events
    
    filereader.onloadstart = (event) =>
      console.log "onloadstart",event if @DEBUG
      cb?(event) for cb in @callbacks.always if @callbacks.always?
      cb?(event) for cb in @callbacks.start if @callbacks.start?
      
    filereader.onprogress = (event) =>
      console.log "onprogress", event if @DEBUG
      cb?(event) for cb in @callbacks.always if @callbacks.always?
      cb?(event) for cb in @callbacks.progress if @callbacks.progress?
      
    filereader.onload = (event) =>
      console.log "onload",event if @DEBUG
      cb?(event) for cb in @callbacks.always if @callbacks.always?
      cb?(event) for cb in @callbacks.load if @callbacks.load?
      
    filereader.onabort = (event) =>
      console.log "onabort",event if @DEBUG
      cb?(event) for cb in @callbacks.always if @callbacks.always?
      cb?(event) for cb in @callbacks.abort if @callbacks.abort?
      
    filereader.onerror = (event) =>
      console.log "onerror",event if @DEBUG
      cb?(event) for cb in @callbacks.always if @callbacks.always?
      cb?(event) for cb in @callbacks.error if @callbacks.error?
      
    filereader.onloadend = (event) =>
      console.log "onloadend",event if @DEBUG
      
      [suffix,] = @file.name.split(".").reverse()
      istext = /text/i.test @file.type
      
      cb?(event) for cb in @callbacks.always if @callbacks.always?
      cb?(event) for cb in @callbacks.loadend if @callbacks.loadend?
      if @callbacks.success?
        for cb in @callbacks.success
          cb?(event.target.result,file.name,suffix,istext)
    
    console?.log "Mime Types: ",@mimes,supported_mimes if @DEBUG
    console?.log "Using Encoding: ",@encoding if @DEBUG
    
    # Start to read:
    filereader.readAsText @file, @encoding
    
  errorHandler: (evt) ->
    switch evt.target.error.code
      when evt.target.error.NOT_FOUND_ERR
        alert "Datei konnte nicht gefunden werden."
      when evt.target.error.NOT_READABLE_ERR
        alert "Datei kann nicht gelesen werden."
      when evt.target.error.ABORT_ERR
        alert "Abgebrochen."
      else
        alert "Ein unbekannter Fehler ist aufgetreten."

# ==============
# = Add a test =
# ==============
window.TextFileReader.works  = new TextFileReader().supported()
window.TextFileReader.ERRORS =
  MIME_TYPE_NOT_SUPPORTED:"MIME_TYPE_NOT_SUPPORTED"
