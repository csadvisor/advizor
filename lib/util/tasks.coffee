async = require('async')
path  = require('path')
debug = require('debug')
h     = require('lib/util/helpers')


tasks = {}

# Copy the student's picture from the camera to your computer.
#
tasks.archivePhoto = ({student, pwd}, callback) ->
  debug '#archivePhoto student', student

  opts =
    filename    : 'photo.jpg'
    dir         : pwd
    destDir     : path.join(pwd, '..', '_photos', '_pending')
    destFilename: "#{student.last}_#{student.first}.jpg"

  h.cpFile(opts, callback)


# notifyMeredith
#
# Meredith's template currently has 6 spots, so send her photographs
# in sets of 6 to be printed.
#
tasks.notifyMeredith = ({pwd}, callback) ->

  async.waterfall [

    (next) ->
      pendingDir = path.join(pwd, '..', '_photos', '_pending')
      debug '#notifyMeredith checking', pendingDir
      h.numberOfFilesInDir(dir: pendingDir, next)

    (number, next) ->
      next(null, number >= 6)

    (shouldTar, next) ->
      return next(null, shouldTar) unless shouldTar

      # tar
      #tar = child_process.spawn 'tar', ['cvzf','','cps10']
      #tar.on 'exit', ->

    (shouldEmail, next) ->
      return next(null, shouldEmail) unless shouldEmail

      # send meredith email

  ], callback


# subscribeAnnounceList
#
tasks.subscribeAnnounceList = ({student}, callback) ->
  headers =
     from    : "#{student.first} #{student.last} <#{student.email}>"
     to      : "cs-students-announce-subscribe@lists.stanford.edu"
  h.sendEmail(headers, callback)


# emailConnie
#
# Send the student's name and email to Connie Chan so that she can
# add them to the Computer Forum Recruiting List.
#
tasks.emailConnie = ({student}, callback) ->
  debug "** Task 4: Emailing Connie"
  
  text = "#{student.first} #{student.last} [#{student.email}]"
  headers =
     text    : text
     to      : "Connie Chan <cchan@cs.stanford.edu>"
     subject : "New Declaree"
  h.sendEmail(headers, callback)


# emailAdivsor
#
# Send the student's new advisor an e-mail informing them of the new
# declaree. Include their transcript and portrait in the email.
#
tasks.emailAdivsor = ({student, advisor, photoLink, pwd},callback) ->
  debug '** Email their advisor'

  headers =
     text    : h.buildEmailBody({student, advisor, photoLink})
     to      : "#{info.advisor.first} #{info.advisor.last} <#{info.advisor.email}>"
     cc      : info.student.email
     subject : "New Advisee"
     attachments: [
       { path: pwd + "/transcript.pdf", name: "#{info.student.last}_#{info.student.first}.pdf" }
     ]
  h.sendEmail(headers, callback)

module.exports = tasks
