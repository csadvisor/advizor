fs  = require 'graceful-fs'
path = require 'path'
_   = require 'underscore'
spawn = require('child_process').spawn
h    = require './util/helpers'
debug   = require('debug')('advizor/lib/board')

wd = process.env.PWD
mapWd = (filenames) ->
  return _.map filenames, (filename) -> wd + '/' + filename

upload_photos = (callback) ->
  errs = []
  fs.readdir '.', (err,res) ->
    students = _.map res, (dir) ->
      if not fs.lstatSync(dir).isDirectory()
        return
      jsonFile = "#{dir}/info.json"
      info = fs.readFileSync(jsonFile)
      info = JSON.parse(info)
      if info.posted
         return
      student = info.student
      dir = wd + '/' + dir
      post = -> h.postToPhotoBoard({student, pwd: dir}, (err) ->
        if not err
          debug "Posted #{student.first} #{student.last}"
        else
          debug err
          errs.push err
        )
      setTimeout post, 2000
  debug 'ERRORS:'
  debug err for err in errs
      

module.exports = upload_photos
