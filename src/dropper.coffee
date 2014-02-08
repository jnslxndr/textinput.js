###!
  Dropper.js – helps you to read dropped files and retrieve its text value
  ... but nice and styled

  @license the unlicense
  @author jens alexander ewald, 2011-2014, lea.io
  @version 0.2.0
  @dependson FancyFileReader.js
!###


$ ->
  $.fn.setEncoding = (encoding) ->
    @data('encoding',encoding)

  $.fn.dropper = (callback,encoding,mimes) ->
    # @setEncoding encoding if encoding
    # style:
    @addClass "dropper"

    # does it work?
    unless FancyFileReader? and FancyFileReader.works?
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
    # = Instantiate a FancyFileReader =
    # ================================
    @reader = new FancyFileReader()

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
      return false unless file

      @reader.setDebug $(@).data("debug")

      # data-encoding attribute:
      encoding = $(@).data('encoding') ? @encoding
      binary   = $(@).data('binary') ? !!@binary
      if $(@).data('accept')
        @reader.setAllowedFileTypes $(@).data('accept')

      callback.start?()
      # and read it defered
      setTimeout (=>@reader.read(file,{encoding,binary})) , 1

      # return nothing
      return null
