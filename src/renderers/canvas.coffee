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

  _drawShape: (color, width, points) ->
    if points and points.length
      @ctx.strokeStyle = color
      @ctx.lineWidth = width
      @ctx.beginPath()
      @ctx.moveTo points[0]...
      for p in points[1..]
        @ctx.lineTo p...
      @ctx.closePath()
      @ctx.stroke()

  drawShape: (color, origin, points) ->
    @ctx.save()
    @ctx.translate origin...

    @ctx.save()

    [width, height] = @_shapeDimensions points

    glowWidth = 6
    padding = glowWidth + 2

    width += padding * 2
    height += padding * 2

    @ctx.rect width / -2,
      height / -2,
      width,
      height
    #@ctx.strokeStyle = 'pink'
    #@ctx.stroke()
    @ctx.clip()

    @ctx.translate -1 * width, -1 * height

    @ctx.shadowColor = color
    @ctx.shadowBlur = glowWidth
    @ctx.shadowOffsetX = width
    @ctx.shadowOffsetY = height

    @_drawShape color, 6, points

    @ctx.restore()

    @_drawShape color, 4, points
    @ctx.restore()

  _shapeDimensions: (points) ->
    width = height = [0, 0]
    for p in points
      width[0] = Math.min p[0], width[0]
      width[1] = Math.max p[0], width[1]
      height[0] = Math.min p[1], height[0]
      height[1] = Math.max p[1], height[1]
    [
      Math.abs(width[0]) + Math.abs(width[1])
      Math.abs(height[0]) + Math.abs(height[1])
    ]

module.exports = CanvasRenderer
