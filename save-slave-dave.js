// Generated by CoffeeScript 1.6.2
(function() {
  var template;

  template = "<div class='saveable-bubble state-active'>\n  <i class='icon-save'></i>\n  <i class='icon-spinner icon-spin'></i>\n  <i class='icon-ok'></i>\n  <i class='icon-remove'></i>\n</div>";

  module.exports = function(input, save, opts) {
    var KEYCODE_ENTER, dontLoseFocus, inProgress, previousSavedValue, saveableBubble, setState, startSave, _ref, _ref1, _ref2, _ref3;

    input = $(input);
    if (opts == null) {
      opts = {};
    }
    if ((_ref = opts.targetElement) == null) {
      opts.targetElement = input;
    }
    if ((_ref1 = opts.getValue) == null) {
      opts.getValue = function() {
        return opts.targetElement.val();
      };
    }
    if ((_ref2 = opts.listen) == null) {
      opts.listen = function(listener) {
        return opts.targetElement.on('keyup', listener);
      };
    }
    if ((_ref3 = opts.saveOnEnter) == null) {
      opts.saveOnEnter = input.is('input');
    }
    inProgress = false;
    previousSavedValue = opts.getValue();
    saveableBubble = $(template);
    opts.targetElement.on('unload', function() {
      return saveableBubble.remove();
    });
    saveableBubble.insertAfter(input);
    opts.targetElement.on('focus', function() {
      return input.addClass('has-focus');
    });
    opts.targetElement.on('blur', function() {
      var checkFocus;

      checkFocus = function() {
        if (!inProgress) {
          input.removeClass('has-focus');
          if (opts.getValue() === previousSavedValue) {
            return;
          }
          saveableBubble.addClass('focus-out');
          return startSave(function() {
            if (input.is(':focus')) {
              return;
            }
            return saveableBubble.removeClass('has-focus focus-out');
          });
        }
      };
      return setTimeout(checkFocus, 250);
    });
    if (opts.saveOnEnter) {
      KEYCODE_ENTER = 13;
      opts.targetElement.on('keyup', function(event) {
        if (event.keyCode !== KEYCODE_ENTER) {
          return;
        }
        event.preventDefault();
        return startSave(function() {
          if (opts.getValue() === previousSavedValue) {
            return saveableBubble.removeClass('has-focus');
          }
        });
      });
    }
    opts.listen(function() {
      if (opts.getValue() !== previousSavedValue && input.is('.has-focus')) {
        return saveableBubble.addClass('has-focus');
      }
    });
    setState = function(newState) {
      saveableBubble.removeClass('state-active state-error state-success state-saving');
      return saveableBubble.addClass("state-" + newState);
    };
    startSave = function(cb) {
      inProgress = true;
      setState('saving');
      return save(function(err) {
        if (err) {
          setState('error');
        } else {
          previousSavedValue = opts.getValue();
          setState('success');
        }
        inProgress = false;
        return setTimeout((function() {
          setState('active');
          return typeof cb === "function" ? cb() : void 0;
        }), 1000);
      });
    };
    dontLoseFocus = function() {
      return _.defer(function() {
        return input.focus();
      });
    };
    return saveableBubble.on('click', function(e) {
      e.preventDefault();
      dontLoseFocus();
      return startSave(function() {
        if (opts.getValue() === previousSavedValue) {
          return saveableBubble.removeClass('has-focus');
        }
      });
    });
  };

}).call(this);
