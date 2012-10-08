#
# @filename test/tasks.coffee
#
tasks  = require('lib/util/tasks')
fs     = require('fs')
path   = require('path')
mkdirp = require('mkdirp')
async  = require('async')
h      = require('lib/util/helpers')
should = require('should')


describe 'tasks', ->

  describe '#archivePhoto', ->

    student = first: 'firstname', last: 'lastname'

    src = __dirname
    srcFile = 'photo.jpg'
    srcPath = path.join(src, srcFile)
    dst = path.join(src, '..', '_photos', '_pending')
    dstFile = "#{student.last}_#{student.first}.jpg"
    dstPath = path.join(dst, dstFile)

    before ->
      fs.writeFileSync srcPath, 'hwefwef'
      mkdirp.sync dst

    after ->
      fs.unlinkSync srcPath
      fs.unlinkSync dstPath
      fs.rmdirSync dst
      fs.rmdirSync path.join(src, '..', '_photos')

    it 'should not return error', (done) ->
      tasks.archivePhoto({student, pwd: src}, done)

    it 'should create file with correct name', ->
      fs.existsSync(dstPath).should.be.ok


      #describe '#notifyMeredith', ->

      #  pwd = __dirname
      #  folder = path.join(pwd, '..', '_photos', '_pending')

      #  before ->
      #    mkdirp.sync folder

      #  after ->
      #    fs.rmdirSync folder
      #    fs.rmdirSync path.join(pwd, '..', '_photos')

      #  it 'should return false if less than 6 spots', (done) ->
      #    tasks.notifyMeredith {pwd}, (err, res) ->
      #      should.not.exist(err)
      #      res.should.not.be.ok
      #      done()

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

  describe '#subscribeAnnounceList', ->

    # *** only works on stanford network ***

    #it 'should send an email', (done) ->
    #  student = email: 'jdubie2233@yahoo.com', last: 'lastname', first: 'firstname'
    #  tasks.subscribeAnnounceList {student}, (err) ->
    #    console.error err
    #    done()

  describe '#emailConnie', ->

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

  describe '#emailAdvisor', ->

  ## emailAdvsior
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
