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
  fs.readdir '.', (err,res) ->
    students = _.map res, (dir) ->
      if not fs.lstatSync(dir).isDirectory()
        return
      info = fs.readFileSync("#{dir}/info.json")
      info = JSON.parse(info)
      student = info.student
      dir = wd + '/' + dir
      debug dir
      h.postToPhotoBoard({student, pwd: dir}, (err) ->
        if not err
          debug "Posted #{student.first} #{student.last}"
        else
          debug err
        )
      

module.exports = upload_photos
