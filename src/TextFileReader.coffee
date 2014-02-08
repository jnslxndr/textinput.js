###!
  FancyFileReader – A simple wrapper class to read File/Blob objects

  @license the unlicense
  @author jens alexander ewald, 2011-2014, lea.io
  @version 0.2.0
!###

class window.FancyFileReader
  callbacks: {}
  DEBUG: false
  constructor: (DEBUG) ->
    return false unless FancyFileReader.supported()

    @reader = new FileReader()

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
    @setDebug DEBUG #sanitize debug value passed in


  setDebug: (@DEBUG) -> @DEBUG = !!@DEBUG
  enableDebug: () -> @setDebug(true)
  enableDebug: () -> @setDebug(false)

  @supported: () ->
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
    return unless mimes?
    mimes = if mimes.length is 1 then mimes[0].split?(',')
    @mimes = mimes ? @mimes
  addAllowedFileTypes: (mimes...) ->
    return unless mimes?
    mimes = if mimes.length is 1 then mimes[0].split?(',')
    @mimes.push mime for mime in mimes

  read: (@file, options) ->

    encoding = options.encoding ? @enconding

    return false unless FancyFileReader.supported()
    filereader = new FileReader()

    supported_mimes = []
    for mime in @mimes
      r = new RegExp(mime,"i")
      supported_mimes.push r.test @file.type

    # unless /text/i.test @file.type
    unless true in supported_mimes
      eevent =
        type: "error"
        code: FancyFileReader.ERRORS.MIME_TYPE_NOT_SUPPORTED
        data: "Filetype not supported"
        giventype: @file.type
        target: @
      cb?(eevent) for cb in @callbacks.error if @callbacks.error?
      return false

    # TODO Refactor with generic method and static array of events

    filereader.onloadstart = (event) =>
      if @DEBUG then console.log "onloadstart",event
      cb?(event) for cb in @callbacks.always if @callbacks.always?
      cb?(event) for cb in @callbacks.start if @callbacks.start?

    filereader.onprogress = (event) =>
      if @DEBUG then console.log "onprogress", event
      cb?(event) for cb in @callbacks.always if @callbacks.always?
      cb?(event) for cb in @callbacks.progress if @callbacks.progress?

    filereader.onload = (event) =>
      if @DEBUG then console.log "onload",event
      cb?(event) for cb in @callbacks.always if @callbacks.always?
      cb?(event) for cb in @callbacks.load if @callbacks.load?

    filereader.onabort = (event) =>
      if @DEBUG then console.log "onabort",event
      cb?(event) for cb in @callbacks.always if @callbacks.always?
      cb?(event) for cb in @callbacks.abort if @callbacks.abort?

    filereader.onerror = (event) =>
      if @DEBUG then @errorHandler(event)
      if @DEBUG then console.log "onerror",event
      cb?(event) for cb in @callbacks.always if @callbacks.always?
      cb?(event) for cb in @callbacks.error if @callbacks.error?

    filereader.onloadend = (event) =>
      if @DEBUG then console.log "onloadend",event

      [suffix,] = @file.name.split(".").reverse()
      istext = /text/i.test @file.type

      cb?(event) for cb in @callbacks.always if @callbacks.always?
      cb?(event) for cb in @callbacks.loadend if @callbacks.loadend?
      if @callbacks.success?
        for cb in @callbacks.success
          cb?(event.target.result,file.name,suffix,istext)

    if @DEBUG
      console?.log "Mime Types: ",@mimes,supported_mimes
      console?.log "Using Encoding: ",encoding

    # fixes a bug in FF - NOT_READABLE_ERR
    encoding = if encoding is undefined or typeof encoding isnt "string" then null else encoding

    # Start to read:
    if !!options.binary
      filereader.readAsBinaryString @file
    else
      filereader.readAsText @file, encoding

  errorHandler: (evt) ->
    switch evt.target.error.code
      when evt.target.error.NOT_FOUND_ERR
        console.error "File not found."
      when evt.target.error.NOT_READABLE_ERR
        console.error "Cannot read file."
      when evt.target.error.ABORT_ERR
        console.error  "Aborted."
      else
        console.error "Sorry, an unkown error occured."

# ==============
# = Add a test =
# ==============
window.FancyFileReader.works  = FancyFileReader.supported()
window.FancyFileReader.ERRORS =
  MIME_TYPE_NOT_SUPPORTED:"MIME_TYPE_NOT_SUPPORTED"
