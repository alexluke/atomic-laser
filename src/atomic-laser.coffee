'use strict'

CanvasRenderer = require './renderers/canvas'
ticker = require 'ticker'

class AtomicLaser
  constructor: ->
    @renderer = CanvasRenderer.create 800, 480
    document.body.appendChild @renderer.canvas

    @ticker = ticker @renderer.el, 60
    @ticker.on 'tick', @update
    @ticker.on 'draw', @draw

  draw:  =>
    @renderer.clear 'black'
    @renderer.drawShape 'white', [100, 100],
      [25, 0]
      [50, 50]
      [25, 35]
      [0, 50]

  update: (dt) =>

module.exports = AtomicLaser
