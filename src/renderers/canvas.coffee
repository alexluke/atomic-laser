'use strict'

class CanvasRenderer
  @create: (width, height) ->
    canvas = document.createElement 'canvas'
    canvas.width = width
    canvas.height = height

    new CanvasRenderer canvas

  constructor: (@canvas) ->
    if typeof @canvas == 'string'
      @canvas = document.getElementById canvas

    if not @canvas.getContext
      throw 'No canvas support'

    @ctx = @canvas.getContext '2d'
    @screen =
      x: @canvas.offsetLeft
      y: @canvas.offsetTop
      width: @canvas.width
      height: @canvas.height

  clear: (color) ->
    @drawRect color or 'white', 0, 0, @screen.width, @screen.height

  drawRect: (color, x, y, width, height) ->
    @ctx.save()
    @ctx.fillStyle = color
    @ctx.fillRect x, y, width, height
    @ctx.restore()

  drawImage: (image, x, y) ->
    @ctx.drawImage image, x, y, image.width, image.height

module.exports = CanvasRenderer
