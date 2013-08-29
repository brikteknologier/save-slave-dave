# save-slave-dave

Dave is a nice little fellow that attaches himself to your form input components
and pops up when the user makes a change, allowing the user to save their
valuable changes!

<img src="http://i.imgur.com/y18Ha6E.jpg"/>

## install

It's recommended that you use this module with
[browserify](https://github.com/substack/node-browserify), as it follows node's
module pattern. **It is assumed that [jQuery](http://jquery.com/) and 
[underscore](http://underscorejs.org/) are defined in the global scope at the
time of use, and that
[font-awesome](http://fortawesome.github.io/Font-Awesome/) is included**. 

Given these things, you can just `npm install save-slave-dave`, then 
`require('save-slave-dave')`.

## when does dave show up, and what does he do?

Dave is a quiet fellow and will not disturb you right away. However, as soon
as you make a change to the targeted input control, he will shimmy on over
and serve up a way to save the changes you've made. As soon as you've saved,
he's gone again! But if you make more changes, he'll be back.

Dave will also assume you don't want to discard your changes when you stop
focusing on an input control, and will save for you before he leaves. Dave
won't stick around on an input control that you're not interested in.

## usage

#### `dave(element, save, [opts])`

The module exports a single function. The easiest way to use save-slave-dave is
with an `<input>` or `<textarea>`. You can do that by attaching it like so:

```javascript
var dave = require('save-slave-dave');

// Dave needs a function do call when it's time to save. Dave will also passed
// that function a callback, which you should call when the saving is done. If
// you couldn't save, you should pass a truthy value as the first argument of
// the callback
var saveToDatabase = function(callback) {
  database.save($("input#amazing-text").val());
}

dave("input#amazing-text", saveToDatabase);
```

But it doesn't stop there! Sometimes you have more complicated input components,
like a tags input! That's no problem. You can also pass an `options` object
specifying the following things:

* `targetElement` (defaults to `element`) Dave will listen to `focus` and `blur`
  events on this element,  and use its value to check for changes if no 
  `getValue` function was given. Dave will also listen to the `keyup` event on
  this element to check for changes if no `listen` function was given`
* `getValue` a function that returns the current value of the input component.
  Defaults to `function() { return opts.targetElement.val() }`
* `listen` a function that attaches a change event listener to the input
  component. The listener should be fired when changes are made to the control's
  value. Defaults to `function (l) { opts.targetElement.on('keyup', l); }`
* `saveOnEnter` if `true`, dave will save the content when the enter key is
  pressed. Not a good idea to set this to true for a textarea. Defaults to true
  if the input is not a textarea.

## styling

Dave should be unique. You should style him to suit your website. But we've
supplied an example [stylus](http://learnboost.github.io/stylus/) style to get 
you started, and to show you what to style. You can see it by looking at the
`example.style.styl` file in the root of the repo. That style will result in a
Dave that looks somewhat like this:

<img src="http://i.imgur.com/iVravHn.gif"/>

## license

MIT. See the LICENSE file.

