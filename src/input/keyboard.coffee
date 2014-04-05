'use strict'

class Keyboard
  @modifiers = [
    'ctrl'
    'alt'
    'shift'
    'meta'
  ]
  @aliases =
    space: 32
    left: 37
    up: 38
    right: 39
    down: 40

  constructor: ->
    @keys = {}
    @modifiers = {}

    document.addEventListener 'keydown', (e) =>
      @onKeyChange e, true
    document.addEventListener 'keyup', (e) =>
      @onKeyChange e, false

  onKeyChange: (e, pressed) ->
    @keys[e.keyCode] = pressed
    @modifiers = 
      ctrl: e.shiftKey
      alt: e.altKey
      shift: e.shiftKey
      meta: e.metaKey

  pressed: (key) ->
    if key in Keyboard.modifiers
      @modifiers[key]
    else if key of Keyboard.aliases
      @keys[Keyboard.aliases[key]]
    else
      @keys[key.toUpperCase().charCodeAt 0]

module.exports = Keyboard
