eco = require 'eco'
fs  = require 'fs'
path = require 'path'
_   = require 'underscore'
spawn = require('child_process').spawn

PDF_NAME = 'photos.pdf'

wd = process.env.PWD
mapWd = (filenames) ->
  return _.map filenames, (filename) -> wd + '/' + filename

gen_pdf = (callback) ->
  fs.readdir '.', (err,res) ->
    res = _.select res, (file) -> path.extname(file) == '.jpg'
    students = _.map res, (file) ->
      photo = path.basename file, '.jpg'
      name_arr = photo.split '_'
      name_arr.reverse()
      name_arr = _.map name_arr, (name) -> name.charAt(0).toUpperCase() + name.slice(1)
      name = name_arr.join ' '
      return {photo,name}
      
    console.log students
    template = fs.readFileSync __dirname + '/util/sub.tex.eco', 'utf-8'
    tex =  eco.render template, students: students
    fs.writeFileSync 'photos.tex', tex
    texi2pdf = spawn 'texi2pdf', mapWd(['photos.tex'])
    texi2pdf.on 'exit', ->
      # clean up
      rm = spawn 'rm', mapWd(['photos.tex', 'photos.log', 'photos.aux'])
      rm.on 'exit', ->
        process.exit 0

module.exports = gen_pdf
