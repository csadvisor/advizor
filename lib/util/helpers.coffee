debug = require('debug')('advizor/lib/util/helpers')
fs = require('fs')
path = require('path')
child_process = require 'child_process'
spawn = child_process.spawn

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
    callback("mv exited with non-zero exit code: #{code}")

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


h.buildEmailBody = ({advisor, student, photoLink}) ->

  switch advisor.title
    when 'professor' then salutation = "Dear Professor #{advisor.last},"
    when 'lecturer'  then salutation = "Dear #{advisor.first},"
    else salutation = "Dear #{advisor.first} #{advisor.last},"

  attachments_location = ''
  attachments_location += "I'm attaching #{student.first}'s transcripts"
  attachments_location += "and including a link to a photo below." if photoLink?

  signature = "Jack Dubie\nCS Course Advisor\nhttp://bit.ly/csadvisor"
  photoLink = '' unless photoLink?

  # create email message
  greeting + '\n' + new_advisee + attachments_location + '\n' + signature + photoLink


module.exports = h
