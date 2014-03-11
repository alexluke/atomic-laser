'use strict'

_ = require 'lodash'

class Shape
  constructor: (@color, @origin, @points) ->
    @pulseSettings =
      size: 1.5
      duration: 500
    @originalPoints = _.cloneDeep @points

  pulse: ->
    @pulseUp = 0

  draw: (renderer) ->
    renderer.drawShape @color, @origin, @points

  update: (dt) ->
    if @pulseUp?
      if @pulseUp >= @pulseSettings.duration
        @pulseUp = null
      else
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
