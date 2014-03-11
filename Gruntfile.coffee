
module.exports = (grunt) ->
  path = require 'path'
  require('load-grunt-tasks')(grunt)

  lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet
  mountFolder = (connect, dir) ->
    connect.static path.resolve dir

  scriptFiles = 'src/**/*.coffee'

  grunt.initConfig
    browserify:
      options:
        transform: ['coffeeify']
        extensions: ['.coffee', '.js']
      dev:
        options:
          debug: true
        src: scriptFiles
        dest: '.tmp/atomic-laser.js'
    connect:
      options:
        port: 9000
        hostname: 'localhost'
      livereload:
        options:
          middleware: (connect) ->
            [
              lrSnippet
              mountFolder connect, '.tmp'
              mountFolder connect, 'src'
            ]
    clean:
      dev: '.tmp'
    watch:
      options:
        livereload: true
      browserify:
        files: scriptFiles
        tasks: 'browserify'
      html:
        files: 'src/index.html'

  grunt.registerTask 'default', [
    'browserify'
    'connect'
    'watch'
  ]
