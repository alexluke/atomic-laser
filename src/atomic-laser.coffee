'use strict'

ticker = require 'ticker'
CanvasRenderer = require './renderers/canvas'
Keyboard = require './input/keyboard'
Shape = require './shape'
Music = require './audio/music'

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
    @music = new Music()
    @music.play 'tech-a-cool'

  draw: (fps) =>
    @renderer.clear 'black'
    @ship.draw @renderer

  update: (dt) =>
    if @music.update()
      @ship.pulse()

    if @keyboard.pressed 'up'
      @ship.rotation = 0
    if @keyboard.pressed 'down'
      @ship.rotation = Math.PI
    if @keyboard.pressed 'left'
      @ship.rotation = Math.PI * 3/2
    if @keyboard.pressed 'right'
      @ship.rotation = Math.PI * 1/2

    speed = 0.2 * dt
    if @keyboard.pressed 'a'
      @ship.origin[0] -= speed
    if @keyboard.pressed 'd'
      @ship.origin[0] += speed
    if @keyboard.pressed 'w'
      @ship.origin[1] -= speed
    if @keyboard.pressed 's'
      @ship.origin[1] += speed

    @ship.update dt

module.exports = AtomicLaser
