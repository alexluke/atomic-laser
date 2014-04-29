'use strict'

class Music
  BEAT_MIN: 0.15
  BEAT_HOLD_TIME: 40
  BEAT_DECAY_RATE: 0.97

  constructor: ->
    AudioContext = window.AudioContext || window.webkitAudioContext
    if not AudioContext
      console.log 'AudioContext not supported'
      return

    @ctx = new AudioContext
    @buffers = {}

  load: (name, callback) ->
    @buffers[name] = null
    request = new XMLHttpRequest()
    request.open 'GET', "audio/music/#{ name }.mp3", true
    request.responseType = 'arraybuffer'

    request.onload = =>
      @ctx.decodeAudioData request.response, (buffer) =>
        @buffers[name] = buffer
        if callback
          callback name

    request.send()

  play: (name) ->
    if name not of @buffers
      @load name, =>
        @play name
    if not @buffers[name]
      return

    nodes = []

    source = @ctx.createBufferSource()
    source.buffer = @buffers[name]
    nodes.push source

    @analyser = @ctx.createAnalyser()
    @analyser.smoothingtimeConstant = 0.8
    @analyser.fftSize = 1024

    binCount = @analyser.frequencyBinCount
    @freqByteData = new Uint8Array binCount
    @levelsCount = 16
    @levelBins = Math.floor binCount / @levelsCount
    @beatCutOff = 0

    nodes.push @analyser

    if window.location.search == '?music'
      nodes.push @ctx.destination

    for i in [0...nodes.length - 1]
      nodes[i].connect nodes[i+1]

    nodes[0].start 0

  update: ->
    if not @analyser?
      return false

    levelsData = []

    @analyser.getByteFrequencyData @freqByteData
    for i in [0...@levelsCount]
      sum = 0
      for j in [0...@levelBins]
        sum += @freqByteData[i * @levelBins + j]
      levelsData[i] = sum / @levelBins / 256

    sum = 0
    for i in [0...@levelsCount]
      sum += levelsData[i]

    level = sum / @levelsCount

    if level > @beatCutOff and level > Music::BEAT_MIN
      @beatCutOff = level * 1.1
      @beatTime = 0

      return true
    else
      if @beatTime <= Music::BEAT_HOLD_TIME
        @beatTime++
      else
        @beatCutOff *= Music::BEAT_DECAY_RATE
        @beatCutOff = Math.max @beatCutOff, Music::BEAT_MIN

       return false

module.exports = Music
