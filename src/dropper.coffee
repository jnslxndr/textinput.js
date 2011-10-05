$ ->
  $.fn.dropper = (callback) ->
    @each =>
      $(@).bind "selectstart", (event) -> event.preventDefault?()
      $(@).addClass "dropper"
      console.log "drops...."