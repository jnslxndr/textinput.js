###!
  Filer.js – helps you to retrieve data from files, you select via a dialog
  ... but nice and styled

  @license the unlicense
  @author jens alexander ewald, 2011-2014, lea.io
  @version 0.2.0
  @dependson FancyFileReader.js
!###

$ ->

  $.fn.filer = (callback,filetypes,@encoding,@binary) ->
    @addClass "filer"

    # does it work?
    unless FancyFileReader? and FancyFileReader.supported?
      @addClass "unsupported"
      console.error "FILE OBJECTS NOT SUPPORTED"
      return @

    # init:
    @bind "selectstart", (event) -> event.preventDefault?()
    accept = filetypes ? @data('accept').split(',')

    keeper = $(@).parent()
    keeper.remove('.filerhelper')
    input = $('<input type="file" accept="'+accept+'" style="position:absolute; height:0!important; width:0!important; z-index:-9999!important;" class="filerhelper">')
    input = $(input).appendTo(keeper)

    @.click (event) =>
      event.stopPropagation?()
      event.preventDefault?()
      $(@).removeClass('success loaded')
      input.click()
      return false

    # ================================
    # = Instantiate a FancyFileReader =
    # ================================
    @reader = new FancyFileReader()

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

      #### END INTERNAL CALLBACKS

    # first bind some styling callback
    @reader.bind internal_cb
    # then bind the given callbacks
    @reader.bind callback


    # ===================================
    # = This is where the magic happens =
    # ===================================
    input.bind "change", (event) =>
      event.stopPropagation?()
      event.preventDefault?()

      [file,] = event.target.files
      return false unless file

      # and read it
      @reader.setDebug $(@).data("debug")

      # data-encoding attribute:
      encoding = $(@).data('encoding') ? @encoding
      binary   = $(@).data('binary') ? !!@binary
      if $(@).data('accept')
        @reader.setAllowedFileTypes $(@).data('accept')

      # call start callbacks
      callback.start?()

      # and read it defered
      setTimeout (=>@reader.read(file,{encoding,binary})) , 1

      # Fixed bug in chrome, would not read the same file again
      input.val("").change();
      # return nothing
      return false
