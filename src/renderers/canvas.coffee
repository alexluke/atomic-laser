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

  _drawShape: (color, width, origin, points) ->
    if points and points.length
      @ctx.strokeStyle = color
      @ctx.lineWidth = width
      @ctx.beginPath()
      @ctx.moveTo @_translatePoint(origin, points[0])...
      for p in points[..]
        @ctx.lineTo @_translatePoint(origin, p)...
      @ctx.closePath()
      @ctx.stroke()

  drawShape: (color, origin, points...) ->
    if points and points.length > 0
      @ctx.save()

      [width, height] = @_shapeDimensions points

      glowWidth = 6
      padding = glowWidth + 2
      @ctx.rect origin[0] - padding, origin[1] - padding, width + padding * 2, height + padding * 2
      @ctx.clip()

      width += padding * 2
      height += padding * 2

      @ctx.shadowColor = color
      @ctx.shadowBlur = glowWidth
      @ctx.shadowOffsetX = width
      @ctx.shadowOffsetY = height

      @_drawShape color, 6, @_translatePoint([-1*width, -1*height], origin), points

      @ctx.restore()

      @ctx.save()
      @_drawShape color, 4, origin, points
      @ctx.restore()

  _translatePoint: (origin, point) ->
    for p, i in point
      p + origin[i]

  # Only handles shapes where the origin is in the upper left
  _shapeDimensions: (points) ->
    width = height = 0
    for p in points
      width = Math.max p[0], width
      height = Math.max p[1], height
    [width, height]

module.exports = CanvasRenderer
