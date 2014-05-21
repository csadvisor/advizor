debug   = require('debug')('advizor/lib/util/helpers')
fs      = require('fs')
path    = require('path')
_       = require('underscore')
{spawn} = require('child_process')
email   = require('emailjs')
config  = require('../../config')
FormData = require('form-data')

h = {}

h.getInfo = ({pwd}, callback) ->
  debug "** Reading info:"
  info = fs.readFileSync("#{pwd}/info.json")
  info = JSON.parse(info)
  debug 'read info:', info
  info.pwd = pwd # tack on pwd
  callback(null, info)

h.writeJSON = ({filename, data, dir}, callback) ->
  fs.writeFile(path.join(dir, filename), JSON.stringify(data), callback)

h.rmFile = ({filename, dir}, callback) ->
  fs.unlink(path.join(dir, filename), callback)

h.mvFile = ({filename, dir, destDir, destFilename}, callback) ->
  from = path.join(dir, filename)
  console.log destFilename
  to = path.join(destDir, destFilename)
  debug '#mvFile (from, to)', from, to
  destFilename ?= filename
  mv = spawn 'mv', [from, to]
  mv.on 'exit', (code) ->
    return callback() if callback && code == 0

h.cpFile = ({filename, dir, destDir, destFilename}, callback) ->
  from = path.join(dir, filename)
  to = path.join(destDir, destFilename)
  debug '#mvFile (from, to)', from, to
  destFilename ?= filename
  cp = spawn 'cp', [from, to]
  cp.on 'exit', (code) ->
    return callback() if callback && code == 0
    callback("cp exited with non-zero exit code: #{code}")
    callback("cp exited with non-zero exit code: #{code}")

h.numberOfFilesInDir = ({dir}, callback) ->
  fs.readdir dir, (err, stat) ->
    return callback(err) if err
    debug "#numberOfFilesInDir _pending photos size: #{stat.length}"
    callback(null, stat.length)

h.renamePhoto = (newName, pwd) ->
  files = fs.readdirSync pwd
  files = _.select files, (file) -> 
    file.match /jpg/
  if files.length > 1
    console.log 'More than one photo in dir'
    process.exit 1
  if files.length == 0
    console.log 'No photo found in dir'
    process.exit 1
 
  oldName = files[0]
  
  opts =
    filename    :  oldName
    dir         :  pwd
    destDir     :  pwd
    destFilename:  newName

  h.mvFile(opts) if oldName != newName
  
    
h.sendEmail = (headers, callback) ->
  debug '#sendEmail'

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

  salutation = switch advisor.title.toLowerCase()
    when 'professor' then "Dear Professor #{advisor.last},"
    when 'lecturer'  then "Dear #{advisor.first},"
    else "Dear #{advisor.first} #{advisor.last},"

  text =
    """

      #{student.first} #{student.last} (#{student.year}) is your new advisee. I'm attaching #{student.first}'s transcripts and photo.

      Alex Eckert
      CS Course Advisor
      http://bit.ly/csadvisor
    """

  # create email message
  salutation + '\n' + text

h.subscribeList = ({student, list}, callback) ->
  headers =
    from    : "#{student.first} #{student.last} <#{student.email}>"
    to      : "#{list}-subscribe@lists.stanford.edu"
    text    : "subscribing to #{list}@lists.stanford.edu"
    subject : "subscribing to #{list}"
  h.sendEmail(headers, callback)


h.postToPhotoBoard = ({student, pwd}, callback) ->
  console.log pwd
  if not ('suid' of student)
    callback("No suid field!")
    return
  if not fs.existsSync("#{pwd}/photo.jpg") 
    callback("No image file!")
    return
  form = new FormData()
  form.append('firstName', student.first)
  form.append('lastName', student.last)
  form.append('suid', student.suid)
  form.append('image', fs.createReadStream("#{pwd}/photo.jpg"))
  form.submit('http://169.254.223.172:3000/upload', (err, res) ->
    # res – response object (http.IncomingMessage)
    if err
      callback(err)
    else
      res.resume()
      callback()
  )



module.exports = h
