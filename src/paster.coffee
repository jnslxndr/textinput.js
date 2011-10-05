###!
  Paster.js helps you with entering textual content via paste
  supports intentional strg/cmd + v only at the moment
!###

$ ->
  $.fn.paster = (callback) ->
    jQuery.event.props.push("clipboardData") # needed?
    @each =>
      $(@).bind "selectstart", (event) -> event.preventDefault?()
      $(@).addClass "paster"
      $(@).find("textarea").remove()
      $(@).click (event) ->
        $(@).find("textarea").remove()
        $(@).addClass("ready")
        dummy = $('<textarea style="position:absolute;left:-9999px;top:-99999em;width:0!important;height:0!important;"/>').appendTo $(@)
        # dummy = $('<textarea style="position:absolute;"/>').appendTo $(@)
        dummy.val("")
        dummy.focus()
        
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

  