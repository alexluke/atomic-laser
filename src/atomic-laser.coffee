'use strict'

ticker = require 'ticker'
CanvasRenderer = require './renderers/canvas'
Keyboard = require './input/keyboard'
Shape = require './shape'

class AtomicLaser
  constructor: ->
    @renderer = CanvasRenderer.create 800, 480
    document.body.appendChild @renderer.canvas

    @keyboard = new Keyboard()

    @ticker = ticker @renderer.el, 60
    @ticker.on 'tick', @update
    @ticker.on 'draw', @draw

    @ship = new Shape 'white', [200, 200], [
      [0, -25]
      [25, 25]
      [0, 10]
      [-25, 25]
    ]
    @tickTime = 0

  draw: (fps) =>
    @renderer.clear 'black'
    @ship.draw @renderer

  update: (dt) =>
    @tickTime += dt
    if @tickTime > 600
      @tickTime = 0
      @ship.pulse()

    if @keyboard.pressed 'a'
      @ship.rotation -= .05
    if @keyboard.pressed 'd'
      @ship.rotation += .05

    @ship.update dt

module.exports = AtomicLaser
