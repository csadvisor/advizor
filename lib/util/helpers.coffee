debug   = require('debug')('advizor/lib/util/helpers')
fs      = require('fs')
path    = require('path')
_       = require('underscore')
{spawn} = require('child_process')
email   = require('emailjs')
config  = require('config')
async   = require('async')

h = {}

h.getInfo = (pwd, callback) ->
  debug "** Reading info:"
  info = fs.readFileSync("#{pwd}/info.json")
  info = JSON.parse(info)
  debug 'read info:', info
  callback(null, info)

h.writeJSON = ({filename, data, dir}, callback) ->
  fs.writeFile(path.join(dir, filename), JSON.stringify(data), callback)

h.rmFile = ({filename, dir}, callback) ->
  fs.unlink(path.join(dir, filename), callback)

h.mvFile = ({filename, dir, destDir, destFilename}, callback) ->
  from = path.join(dir, filename)
  to = path.join(destDir, destFilename)
  debug '#mvFile (from, to)', from, to
  destFilename ?= filename
  mv = spawn 'mv', [from, to]
  mv.on 'exit', (code) ->
    return callback() if code == 0

h.cpFile = ({filename, dir, destDir, destFilename}, callback) ->
  from = path.join(dir, filename)
  to = path.join(destDir, destFilename)
  debug '#mvFile (from, to)', from, to
  destFilename ?= filename
  cp = spawn 'cp', [from, to]
  cp.on 'exit', (code) ->
    return callback() if code == 0
    callback("cp exited with non-zero exit code: #{code}")
    callback("cp exited with non-zero exit code: #{code}")

h.numberOfFilesInDir = ({dir}, callback) ->
  fs.readdir dir, (err, stat) ->
    return callback(err) if err
    debug "#numberOfFilesInDir _pending photos size: #{stat.length}"
    callback(null, stat.length)

h.sendEmail = (headers, callback) ->
  defaults =
    from    : 'Course Advisor <advisor@cs.stanford.edu>'
    to      : 'Course Advisor <advisor@cs.stanford.edu>'
    bcc     : 'csadvisor.bcc@gmail.com'
    subject : 'test email'
    text    : 'test text'
  _.defaults(headers, defaults)

  message = email.message.create(headers)
  config.smtp.send(message, callback)


h.buildEmailBody = ({advisor, student}) ->

  salutation = switch advisor.title
    when 'professor' then "Dear Professor #{advisor.last},"
    when 'lecturer'  then "Dear #{advisor.first},"
    else "Dear #{advisor.first} #{advisor.last},"

  text =
    """
      #{student.first} #{student.last} is your new advisee. I'm attaching #{student.first}'s transcripts and photo.

      Jack Dubie
      CS Course Advisor
      http://bit.ly/csadvisor"
    """

  # create email message
  salutation + '\n' + text


module.exports = h
