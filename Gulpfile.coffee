gulp = require 'gulp'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
coffee = require 'gulp-coffee'
gulpif = require 'gulp-if'
sass = require 'gulp-sass'

gulp.task 'build-js', ->
  gulp.src([
    'assets/js/vendor/*',
    'assets/js/components/*'
    'assets/js/app.coffee'
    ])
  .pipe gulpif(/[.]coffee$/, coffee())
  .pipe uglify()
  .pipe concat 'script.js'
  .pipe gulp.dest 'build/'

gulp.task 'css', ->
  gulp.src ['./assets/css/vendor/*', './assets/css/*']
  .pipe gulpif /[.]scss$/, sass()
  .pipe concat 'style.css'
  .pipe gulp.dest 'build/'

gulp.task 'default',
  ['build-js', 'css']
