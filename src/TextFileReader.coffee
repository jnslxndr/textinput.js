class TextFileReader
  callbacks: 
    loadstart: []
    progress:  []
    load:      []
    abort:     []
    error:     []
    loadend:   []
    # extra events hooked to internal
    success:   []
    always:    []
  
  constructor: (@filereader) ->
    try
      @filereader = @filereader ? new FileReader()
    catch error
      console.warn ""
    
    @supported
  
  works: () -> @supported()
  supported: () ->
    try
      FileReader? and File?
    catch error
      false
  
  bind: (callbacks...) ->
    console.log callbacks
    @add_cb callbacks...
      
  add_cb: (cb) ->
    for event,func of cb
      console.log event,func,@callbacks[event]
      @callbacks[event].push?(func) if @callbacks[event]
    console.log "added callback: ",cb,@callbacks
  
  read: (@file) ->
    return false if not @supported()
    @filereader = new FileReader() unless @filereader?
      
    @filereader.onloadstart = (event) ->
      $(@).addClass("loadstart")
      console.log "onloadstart",event if @DEBUG
      callback.start?(event)
    @filereader.onprogress = (event) ->
      $(@).addClass("loaded progress")
      console.log "onprogress", event if @DEBUG
      callback.progress?(event)
    @filereader.onload = (event) ->
      $(@).addClass("loaded load")
      console.log "onload",event if @DEBUG
      callback.load?(event)
    @filereader.onabort = (event) ->
      $(@).addClass("loaded abort")
      console.log "onabort",event if @DEBUG
      callback.abort?(event)
    @filereader.onerror = (event) ->
      $(@).addClass("loaded error")
      console.log "onerror",event if @DEBUG
      callback.error?(event)
    @filereader.onloadend = (event) =>
      $(@).addClass("loaded success")
      console.log "onloadend",event if @DEBUG
      [suffix,] = file.name.split(".").reverse()
      istext = /text/i.test file.type
      callback.success?(event.target.result,file.name,suffix,istext)
    
    # Start to read:
    # @filereader.readAsText @file

    

# make it public:
window.TextFileReader = TextFileReader