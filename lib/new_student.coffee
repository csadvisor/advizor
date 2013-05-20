fs    = require 'fs'
path  = require 'path'
async = require 'async'
_     = require 'underscore'
spawn = require('child_process').spawn


local = {}
Object.defineProperty local, 'stdin', do ->
  stdin = null # private variable
  get: () ->
    return stdin if _stdin?
    return stdin = process.openStdin()
  enumerable: false


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
  local.stdin.once 'data', (chunk, key) ->
    if chunk.toString() != "y\n"
      console.log 'students transcript is not latest pdf downloaded'
      process.exit 0
    else
      callback null, latest_file

get_info = (callback) ->
  async.series
    first : (cb) -> get_field 'enter student\'s first name: '    , cb
    last  : (cb) -> get_field 'enter student\'s last name: '     , cb
    email : (cb) -> get_field 'enter student\'s email: '         , cb
    year  : (cb) -> get_field 'enter student\'s grad year: '     , cb
    track : (cb) -> get_field 'enter student\'s intended track: ', cb
  , callback

get_advisor_info = (callback) ->
  async.series
    first : (cb) -> get_field 'enter advisor\'s first name: ', cb
    last  : (cb) -> get_field 'enter advisor\'s last name: ',  cb
    email : (cb) -> get_field 'enter advisor\'s email: ',      cb
    title : (cb) -> get_field 'enter advisor\'s title: ',      cb
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
  local.stdin.once 'data', (chunk) ->
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
  dst_folder = path.join(process.cwd(), folder)
  src = path.join(process.env.HOME, 'Downloads', info.file)
  dst = path.join(dst_folder, 'transcript.pdf')
  info_file = path.join(dst_folder, 'info.json')

  async.series [
    (cb) -> create_folder dst_folder, cb
    (cb) -> cpy           src, dst, cb
    (cb) -> write_info    info_file, info, cb
  ], (err,res) ->
    if err?
      console.log err
      process.exit 1
    else
      console.log "Created student folder: #{dst_folder}"
      process.exit 0


module.exports = main
