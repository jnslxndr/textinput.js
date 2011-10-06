###!
  Dropper helps you to read dropped files and retrieve its text value
!###

$ ->
  errorHandler = (evt) ->
    switch evt.target.error.code
      when evt.target.error.NOT_FOUND_ERR
        alert "Datei konnte nicht gefunden werden."
      when evt.target.error.NOT_READABLE_ERR
        alert "Datei kann nicht gelesen werden."
      when evt.target.error.ABORT_ERR
        alert "Abgebrochen."
      else
        alert "Ein unbekannter Fehler ist aufgetreten."
  
  $.fn.dropper = (callback) ->
    @DEBUG = true
    # style:
    @addClass "dropper"
    
    # jQuery props
    jQuery.event.props.push("dataTransfer") # enable dataTransfer for events
    
    # init:
    # @each ->
    $(document).bind "dragover drop",(event) -> event.preventDefault?()
    @bind "selectstart", (event) -> event.preventDefault?()
    
    # ===============
    # = Visual Cues =
    # ===============
    @
    .removeClass("loaded success dragover dropped")
    .bind "dragover",(event) -> 
      event.preventDefault?()
      event.stopPropagation()
      $(@).addClass("dragover").removeClass "dropped"
      false
    .bind "mouseout dragend", () ->
      $(@).removeClass "dragover dropped"
    
    # ===================
    # = The Drop itself =
    # ===================
    @.bind "drop", (event) =>
      # update styles:
      $(@).removeClass("dragover").addClass "dropped"
      
      # prevent default:
      event.stopPropagation()
      event.preventDefault()
      
      # =======================
      # = Find the first File =
      # =======================
      [file,] = event.dataTransfer.files
      
      # ================================
      # = Instantiate a TextFileReader =
      # ================================
      reader = new TextFileReader()
      
      # bind the callbacks
      reader.bind callback,{always:(event) => $(@).addClass(event.type)}
      
      # console.log file,callback
      # if @DEBUG
      #   try
      #     console.log "#{file.name}, #{file.type} (#{file.size}, #{file.lastModifiedDate.toLocaleDateString()})"
      #   catch error
      #     console.log "ups", "#{file.name}, #{file.type} (#{file.size})"
      
      # and read the file
      reader.read file
      
      # # ======================================================
      # # = Read the file and call callback with text or bytes =
      # # ======================================================
      # reader = new FileReader()
      # reader.onloadstart = (event) ->
      #   $(@).addClass("loadstart")
      #   console.log "onloadstart",event if @DEBUG
      #   callback.start?(event)
      # reader.onprogress = (event) ->
      #   $(@).addClass("loaded progress")
      #   console.log "onprogress", event if @DEBUG
      #   callback.progress?(event)
      # reader.onload = (event) ->
      #   $(@).addClass("loaded load")
      #   console.log "onload",event if @DEBUG
      #   callback.load?(event)
      # reader.onabort = (event) ->
      #   $(@).addClass("loaded abort")
      #   console.log "onabort",event if @DEBUG
      #   callback.abort?(event)
      # reader.onerror = (event) ->
      #   $(@).addClass("loaded error")
      #   console.log "onerror",event if @DEBUG
      #   callback.error?(event)
      # reader.onloadend = (event) =>
      #   $(@).addClass("loaded success")
      #   console.log "onloadend",event if @DEBUG
      #   [suffix,] = file.name.split(".").reverse()
      #   istext = /text/i.test file.type
      #   callback.success?(event.target.result,file.name,suffix,istext)
      # 
      # # Start to read:
      # reader.readAsText file
