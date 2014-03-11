'use strict'

class Shape
  constructor: (@color, @origin, @points) ->

  pulse: ->

  draw: (renderer) ->
    renderer.drawShape @color, @origin, @points

module.exports = Shape
