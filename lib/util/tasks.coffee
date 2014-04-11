async = require('async')
path  = require('path')
debug = require('debug')('advizor/lib/util/tasks')
h     = require('./helpers')
_     = require('underscore')


tasks = {}

# Copy the student's picture from the camera to your computer.
#
tasks.archivePhoto = ({student, pwd}, callback) ->
  debug '#archivePhoto student', student

  newPhotoName = 'photo.jpg'

  h.renamePhoto(newPhotoName, pwd)

  opts =
    filename    : newPhotoName
    dir         : pwd
    destDir     : path.join(pwd, '..', '..',  '_photos', '_pending')
    destFilename: "#{student.last}_#{student.first}.jpg"

  h.cpFile(opts, callback)


# notifyMeredith
# TODO
#
# Meredith's template currently has 6 spots, so send her photographs
# in sets of 6 to be printed.
#
#tasks.notifyMeredith = ({pwd}, callback) ->
#
#  async.waterfall [
#
#    (next) ->
#      pendingDir = path.join(pwd, '..', '_photos', '_pending')
#      debug '#notifyMeredith checking', pendingDir
#      h.numberOfFilesInDir(dir: pendingDir, next)
#
#    (number, next) ->
#      next(null, number >= 6)
#
#
#    (shouldPdf, next) ->
#      return next(null, shouldPdf) unless shouldPdf
#
#      # generate photo email
#
#    (shouldEmail, next) ->
#      return next(null, shouldEmail) unless shouldEmail
#
#      # send meredith email
#
#    (shouldTar, next) ->
#      return next(null, shouldTar) unless shouldTar
#
#      # tar and archive old photos
#
#      #tar = child_process.spawn 'tar', ['cvzf','','cps10']
#      #tar.on 'exit', ->
#
#  ], callback

# trackSpecificTasks
#
tasks.trackSpecificTasks = ({student}, callback) ->
  switch student.track
    when 'HCI'
      tasks = [
        (cb) ->
          debug "HCI Task: emailing hci-course-advisor"
          text = "#{student.first} #{student.last} [#{student.email}]"
          headers =
             text    : text
             to      : "hci-course-advisor@cs.stanford.edu"
             subject : "New HCI Declaree"
          h.sendEmail(headers, cb)
        (cb) ->
          debug "HCI Task: Subscribing to hci-students"
          h.subscribeList({list: 'hci-students', student}, cb)
        (cb) ->
          debug "HCI Task: Subscribing to hci-student-jobs"
          h.subscribeList({list: 'hci-student-jobs', student}, cb)
      ]
      async.series(tasks, callback)
    else
      callback()

# subscribe

# subscribeAnnounceList
#
tasks.subscribeAnnounceList = ({student}, callback) ->
  h.subscribeList({list: 'cs-students-announce', student}, callback)

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
     to      : "forumstaff@cs.stanford.edu"
     subject : "New Declaree"
  h.sendEmail(headers, callback)


# emailAdvisor
#
# Send the student's new advisor an e-mail informing them of the new
# declaree. Include their transcript and portrait in the email.
#
tasks.emailAdvisor = ({student, advisor, photoLink, pwd}, callback) ->
  debug '** Email their advisor'

  headers =
     text    : h.buildEmailBody({student, advisor, photoLink})
     to      : "#{advisor.first} #{advisor.last} <#{advisor.email}>"
     cc      : student.email
     subject : "New Advisee"
     attachment: [
       { path: pwd + "/transcript.pdf", name: "#{student.last}_#{student.first}.pdf" }
       { path: pwd + "/photo.jpg", name: "#{student.last}_#{student.first}.jpg" }
     ]
  h.sendEmail(headers, callback)


# facebookPost
#
# Send email to IFTTT to trigger facebook page wall post
# This is much easier than dealer with FB API
tasks.facebookPost = ({student, message, pwd}, callback) ->
  debug '** Post to facebook'

  headers =
     text    : message
     to      : "trigger@ifttt.com"
     subject : "New CS Major"
     attachment: [
       { path: pwd + "/photo.jpg", name: "#{student.last}_#{student.first}.jpg" }
     ]
  h.sendEmail(headers, callback)

module.exports = tasks
