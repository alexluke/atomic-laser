'use strict'

ticker = require 'ticker'
CanvasRenderer = require './renderers/canvas'
Shape = require './shape'

class AtomicLaser
  constructor: ->
    @renderer = CanvasRenderer.create 800, 480
    document.body.appendChild @renderer.canvas

    @ticker = ticker @renderer.el, 60
    @ticker.on 'tick', @update
    @ticker.on 'draw', @draw

    @ship = new Shape 'white', [100, 100], [
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
    @ship.update dt

module.exports = AtomicLaser
