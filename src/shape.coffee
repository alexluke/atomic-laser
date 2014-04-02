'use strict'

_ = require 'lodash'

class Shape
  constructor: (@color, @origin, @points) ->
    @pulseSettings =
      size: 1.3
      duration: 100
    @originalPoints = _.cloneDeep @points
    @rotation = Math.PI * .5

  pulse: ->
    @pulseUp = 0

  draw: (renderer) ->
    renderer.drawShape @color, @origin, @points, @rotation

  update: (dt) ->
    if @pulseUp? or @pulseDown?
      if @pulseDown < 0
        @pulseDown = null
      if @pulseUp >= @pulseSettings.duration
        @pulseUp = null
        @pulseDown = @pulseSettings.duration
      if @pulseDown?
        @pulseDown -= dt
      else if @pulseUp?
        @pulseUp += dt

      # TODO: Easing?
      for p, i in @points
        p[0] = @_lerp @originalPoints[i][0], @originalPoints[i][0] * @pulseSettings.size, @pulseUp / @pulseSettings.duration
        p[1] = @_lerp @originalPoints[i][1], @originalPoints[i][1] * @pulseSettings.size, @pulseUp / @pulseSettings.duration
        @points[i] = p

    return

  _lerp: (start, end, t) ->
    start + (end - start) * t

module.exports = Shape
