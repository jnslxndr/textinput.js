###!
  Filer helps you to retrieve data from files, you select via a dialog
  ... but nice and styled
  
  @dependson TextFileReader.js
  
  licensed under the unlicense
  jens alexander ewald, 2011, ififelse.net
!###

$ ->
  
  $.fn.filer = (callback,filetypes) ->
    @addClass "filer"
    
    # does it work?
    unless TextFileReader? and TextFileReader.works?
      @addClass "unsupported"
      console.error "FILE OBJECTS NOT SUPPORTED"
      return @
    
    # init:
    @bind "selectstart", (event) -> event.preventDefault?()
    filetypes = filetypes ? []
    accept = filetypes.join(", ")
    keeper = $(@).parent()
    input = $('<input type="file" accept="'+accept+'" style="position:absolute; height:0!important; width:0!important; z-index:-9999!important;" id="filerhelper">')
    keeper.remove('#filerhelper')
    input = $(input).appendTo(keeper)
    @.click (event) =>
      $(@).removeClass('success loaded')
      input.click()
      return false
    
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
    
    
    # ===================================
    # = This is where the magic happens =
    # ===================================
    input.change (event) =>
      event.preventDefault?()
      
      [file,] = event.target.files
      return false unless file
      
      # = do some type checking
      # if filetypes?
      #   filetypes = [filetypes] if not (filetypes instanceof Array)
      #   return false unless file.type in filetypes
      
      # = we are lucky and can process
      $(@).addClass("success")
      
      # if @DEBUG
      #   try
      #     console.log "#{file.name}, #{file.type} (#{file.size}, #{file.lastModifiedDate.toLocaleDateString()})"
      #   catch error
      #     console.log "ups", "#{file.name}, #{file.type} (#{file.size})"
      
      # and read it
      @reader.read file if file?
      
      # return nothing
      return null
