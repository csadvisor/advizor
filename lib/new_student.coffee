fs    = require 'fs'
async = require 'async'
_     = require 'underscore'
spawn = require('child_process').spawn

stdin = process.openStdin()

# main function
main = ->
  async.series
    file     : confirm_file
    student  : get_info
    advisor  : get_advisor_info
  , (err,res) ->
    add_student res

confirm_file = (callback) ->
  latest_file = get_latest_pdf()
  process.stdout.write "Is this their file #{latest_file}? (y/n): "
  stdin.once 'data', (chunk, key) ->
    if chunk.toString() != "y\n"
      console.log 'students transcript is not latest pdf downloaded'
      process.exit 0
    else
      callback null, latest_file

get_info = (callback) ->
  async.series
    first : (cb) -> get_field 'enter student\'s first name: ', cb
    last  : (cb) -> get_field 'enter student\'s last name: ',  cb
    email : (cb) -> get_field 'enter student\'s email: ',      cb
  , callback

get_advisor_info = (callback) ->
  async.series
    first : (cb) -> get_field 'enter advisor\'s first name: ', cb
    last  : (cb) -> get_field 'enter advisor\'s last name: ',  cb
    title : (cb) -> get_field 'enter advisor\'s title: ',                 cb
    email : (cb) -> get_field 'enter advisor\'s email: ',      cb
  , callback

get_latest_pdf = ->
  dir = "#{process.env.HOME}/Downloads"
  files = fs.readdirSync dir
  files = _.select files, (file) ->
    file.match /pdf/
  ctimes = _.map files, (file) ->
    #console.log dir + "/#{file}"
    stats = fs.lstatSync dir + "/#{file}"
    ctime = stats.ctime.getTime()
    return {file,ctime}

  ctimes = _.sortBy ctimes, (entry) -> -entry.ctime
  lastest_file = ctimes[0].file

get_field = (question, callback) ->
  process.stdout.write question
  stdin.once 'data', (chunk) ->
    chunk = chunk.toString()
    chunk = chunk.split('\n')[0]
    callback null, chunk

create_folder = (dst, callback) ->
  mkdir = spawn 'mkdir', [dst]
  mkdir.on 'exit', (code) -> callback null, code

cpy = (src, dst, callback) ->
  cp = spawn 'mv', [src, dst]
  cp.on 'exit', (code) -> callback null, code

write_info = (file, info, callback) ->
  obj =
    student: info.student
    advisor: info.advisor
    message: "#{info.student.first} #{info.student.last} just declared Computer Science. "

  fs.writeFileSync file, JSON.stringify obj, undefined, '\t'

  callback null, true

add_student = (info) ->
  folder = "#{info.student.last.toLowerCase()}_#{info.student.first.toLowerCase()}"
  src = "#{process.env.HOME}/Downloads/#{info.file}"
  dst = "#{process.env.HOME}/Dropbox/Developer/course_advisor/declaring/_pending/#{folder}/transcript.pdf"
  info_file = "#{process.env.HOME}/Dropbox/Developer/course_advisor/declaring/_pending/#{folder}/info.json"
  new_dir = "#{process.env.HOME}/Dropbox/Developer/course_advisor/declaring/_pending/#{folder}"

  async.series [
    (cb) -> create_folder new_dir, cb
    (cb) -> cpy           src, dst, cb
    (cb) -> write_info    info_file, info, cb
  ], (err,res) ->
    if err?
      console.log err
      process.exit 1
    else
      console.log "Created student folder: #{new_dir}"
      process.exit 0


module.exports = main
