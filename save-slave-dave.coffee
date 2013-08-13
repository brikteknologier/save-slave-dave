template = """
  <div class='saveable-bubble state-active'>
    <i class='icon-save'></i>
    <i class='icon-spinner icon-spin'></i>
    <i class='icon-ok'></i>
    <i class='icon-remove'></i>
  </div>
"""

# Use this with an html form element (like input, textarea etc) which has a
# readable value that you want to save.
# `input` is the element to use
# `save` is the function that will be called when the user wants to save. This
#        function should take a callback, and the callback should be passed 
#        an error if the saving failed.
# `opts` is optional, and has the following settings/defaults:
#   
#   `targetElement` the element to listen to for focus, blur and change events.
#                   if no 'getValue' function is provided, this element is also
#                   used to read the value
#   `getValue` a function which returns the current value of the component. 
#              defaults to `-> input.val()`
#   `listen` a function to add a listener to the event that indicates changes on
#            the target component. defaults to
#            `(listener) -> opts.targetElement.on('keyup', listener)`
#
module.exports = (input, save, opts) ->
  input = $(input)

  opts ?= {}
  opts.targetElement ?= input
  opts.getValue ?= -> opts.targetElement.val()
  opts.listen ?= (listener) -> opts.targetElement.on('keyup', listener)
  opts.saveOnEnter ?= input.is('input')
  
  inProgress = false
  previousSavedValue = opts.getValue()
  saveableBubble = $(template)
  opts.targetElement.on('unload', -> saveableBubble.remove())
  saveableBubble.insertAfter(input)

  opts.targetElement.on 'focus', -> input.addClass('has-focus')
  opts.targetElement.on 'blur', ->
    # Checks if the save button was clicked or if the user just focused another
    # element. Starts saving if the content had changed and the user was just
    # focusing another element
    checkFocus = ->
      if not inProgress
        input.removeClass('has-focus')
        return if opts.getValue() == previousSavedValue
        saveableBubble.addClass('focus-out')
        startSave ->
          return if input.is(':focus')
          saveableBubble.removeClass('has-focus focus-out')

    # Since the 'blur' event fires quite a while before the 'click' event, we
    # need to defer `checkFocus` for a little while, so we can properly check if
    # the user clicked the save button, or if they were actually trying to lose
    # focus on the text input. 250ms is arbitrary, but seems to work.
    setTimeout(checkFocus, 250)

  if opts.saveOnEnter
    KEYCODE_ENTER = 13
    opts.targetElement.on 'keyup', (event) ->
      return if event.keyCode isnt KEYCODE_ENTER
      event.preventDefault()
      startSave ->
        if opts.getValue() == previousSavedValue
          saveableBubble.removeClass('has-focus')


  opts.listen ->
    if (opts.getValue() != previousSavedValue && input.is('.has-focus'))
      saveableBubble.addClass('has-focus')

  setState = (newState) ->
    saveableBubble.removeClass 'state-active state-error state-success state-saving'
    saveableBubble.addClass "state-#{newState}"

  startSave = (cb) ->
    inProgress = true
    setState('saving')
    save (err) ->
      if (err)
        setState('error')
      else
        previousSavedValue = opts.getValue()
        setState('success')
      inProgress = false
      setTimeout((-> setState('active'); cb?()), 1000)

  dontLoseFocus = -> _.defer -> input.focus()
  saveableBubble.on 'click', (e) ->
    e.preventDefault()
    dontLoseFocus()
    startSave ->
      if opts.getValue() == previousSavedValue
        saveableBubble.removeClass('has-focus')

