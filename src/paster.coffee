###!
  Paster.js – Helps you with entering textual content via paste
  supports intentional strg/cmd + v only at the moment

  @license the unlicense
  @author jens alexander ewald, 2011-2014, lea.io
  @version 0.2.0
  @dependson FancyFileReader.js
!###

$ ->
  $.fn.paster = (callback) ->
    jQuery.event.props.push("clipboardData") # needed?
    @each =>
      $(@).bind "selectstart", (event) -> event.preventDefault?()
      $(@).addClass "paster"
      $(@).find("textarea").remove()
      $(@).click (event) ->
        $(@).addClass("ready")
        $(@).find("textarea").remove()
        dummy = $('<textarea style="position:absolute;border:none;width:1;height:1;z-index:-999;opacity:0;"/>').appendTo $(@)
        dummy.one "blur", (event) ->
          $(@).closest('.paster').removeClass("ready")
          $(@).remove()

        dummy.one "paste", (event) ->
          $(@).closest('.paster').removeClass("ready")

          # try to use the clipboard, else, use the dummy
          clip = event.clipboardData ? event.originalEvent.clipboardData

          if clip
            type = clip.types ? "Text"
            data = clip.getData?(type)
            callback?(data,event)
            $(@).remove()
          else
            $(@).one "change keyup", (event) ->
              event.preventDefault?()
              data = $(@).val()
              callback?(data,event)
              $(@).remove() # remove the focus from the textfield

        dummy.val("")
        dummy.focus()
