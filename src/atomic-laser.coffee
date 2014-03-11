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
    @renderer.clear()

  update: (dt) =>

module.exports = AtomicLaser
