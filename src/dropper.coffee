###!
  Dropper helps you to read dropped files and retrieve its text value
  ... but nice and styled
  
  @dependson TextFileReader.js
  
  licensed under the unlicense
  jens alexander ewald, 2011, ififelse.net
!###


$ ->
  $.fn.dropper = (callback) ->
    # style:
    @addClass "dropper"
    
    # does it work?
    unless TextFileReader? and TextFileReader.works?
      @addClass "unsupported"
      console.error "FILE OBJECTS NOT SUPPORTED"
      return @
    
    # jQuery props
    jQuery.event.props.push("dataTransfer") # enable dataTransfer for events
    
    # init:
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


    # ===========================================
    # = The internal callback for styling state =
    # ===========================================
    internal_cb =
      success: (event) => 
        $(@).addClass("success")
      always: (event) => 
        # remove all classes with on** before we enter a fresh read
        $(@)
        .removeClass (index, klass) -> 
          result = []
          f = null
          r = /on\w+/gi
          # search globally
          while f = r.exec(klass) 
            result.push f[0]
          result.map((el) -> $.trim(el)).join(" ")
        .addClass("on#{event.type}")
    
    # ================================
    # = Instantiate a TextFileReader =
    # ================================
    @reader = new TextFileReader()
    
    # first bind some styling callback
    @reader.bind internal_cb
    # then bind the given callbacks
    @reader.bind callback
    

    # ===================
    # = The Drop itself =
    # ===================
    @.bind "drop", (event) =>
      # prevent default:
      event.stopPropagation()
      event.preventDefault()
      
      # update styles:
      $(@).removeClass("dragover sucess").addClass "dropped"
      
      # =======================
      # = Find the first File =
      # =======================
      [file,] = event.dataTransfer.files
      
      # and read it
      @reader.read file if file?
      
      # return nothing
      return null
      