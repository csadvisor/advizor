#
# @filename test/tasks.coffee
#

describe 'tasks', ->

  ## Copy the student's picture from the camera to your computer.
  ##
  #tasks.archivePhoto = (info,callback) ->
  #  debug '#processPhoto', info
  #
  #  pwd = process.env.PWD
  #
  #  opts =
  #    filename    : 'photo.jpg'
  #    dir         : pwd
  #    destDir     : path.join(pwd, '..', '_photos', '_pending')
  #    destFilename: "#{info.student.last}_#{info.student.first}.jpg"
  #
  #  h.mvFile(opts, callback)
  #
  #
  ## notifyMeredith
  ##
  ## Meredith's template currently has 6 spots, so send her photographs
  ## in sets of 6 to be printed.
  ##
  #tasks.notifyMeredith = (callback) ->
  #
  #  async.waterfall [
  #
  #    (next) ->
  #      pendingDir = path.join(dir, '..', '_photos', '_pending')
  #      debug '#notifyMeredith checking', pendingDir
  #      h.numberOfFilesInDir(dir: pendingDir, next)
  #
  #    (number, next) ->
  #      next(null, number >= 6)
  #
  #    (shouldTar, next) ->
  #      return next(email) unless shouldTar
  #
  #      # tar
  #      #tar = child_process.spawn 'tar', ['cvzf','','cps10']
  #      #tar.on 'exit', ->
  #
  #    (shouldEmail, next) ->
  #      return next(email) unless shouldEmail
  #
  #      # send meredith email
  #
  #  ], (err, res) ->
  #
  #
  ## subscribeAnnounceList
  ##
  #tasks.subscribeAnnounceList = ({student}, callback) ->
  #  headers =
  #     from    : "#{student.first} #{student.last} <#{student.email}>"
  #     to      : "cs-students-announce-subscribe@lists.stanford.edu"
  #  h.sendEmail(headers, callback)
  #
  #
  ## emailConnie
  ##
  ## Send the student's name and email to Connie Chan so that she can
  ## add them to the Computer Forum Recruiting List.
  ##
  #tasks.emailConnie = ({student}, callback) ->
  #  debug "** Task 4: Emailing Connie"
  #  
  #  text = "#{info.student.first} #{info.student.last} [#{info.student.email}]"
  #  headers =
  #     text    : text
  #     to      : "Connie Chan <cchan@cs.stanford.edu>"
  #     subject : "New Declaree"
  #  h.sendEmail(headers, callback)
  #
  #
  ## emailAdivsor
  ##
  ## Send the student's new advisor an e-mail informing them of the new
  ## declaree. Include their transcript and portrait in the email.
  ##
  #tasks.emailAdivsor = ({student, advisor, photoLink},callback) ->
  #  debug '** Email their advisor'
  #
  #  headers =
  #     text    : h.buildEmailBody({student, advisor, photoLink})
  #     to      : "#{info.advisor.first} #{info.advisor.last} <#{info.advisor.email}>"
  #     cc      : info.student.email
  #     subject : "New Advisee"
  #     attachments: [
  #       { path: pwd + "/transcript.pdf", name: "#{info.student.last}_#{info.student.first}.pdf" }
  #     ]
  #  h.sendEmail(headers, callback)
  #
  #module.exports = tasks
