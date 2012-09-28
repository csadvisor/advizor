h = require('lib/util/helpers')
should = require('should')
fs = require('fs')
path = require('path')
mkdirp = require('mkdirp')

describe 'util/helpers', ->
  describe '#getInfo', ->

    before (ready) ->
      info =
        student:
          first:  "Joseph"
          last:   "Baena"
          email:  "jbaena@stanford.edu"
        advisor:
          first: "Mehran"
          last: "Sahami"
          title: "professor"
          email: "sahami@cs.stanford.edu"
        message: "Joseph Baena just declared Computer Science. Welcome to the family, Broseph."
      h.writeJSON({filename: 'info.json', data: info, dir: __dirname}, ready)

    after (finished) ->
      h.rmFile({filename: 'info.json', dir: __dirname}, finished)

    it 'should work', (done) ->
      h.getInfo __dirname, (err, info) ->
        info.should.have.keys 'student', 'advisor', 'message'
        console.error info
        done()

  describe '#writeJSON', ->

    filename = 'wefweff.test'
    dir = __dirname
    data = foo: 'bar'

    after (done) ->
      h.rmFile({filename, dir}, done)

    before (done) ->
      h.writeJSON({filename, data, dir}, done)

    it 'should', ->
    #it 'should create file', (done) ->
    #it 'should have correct content', (done) ->

  describe '#rmFile', ->
    filename = 'test.txt'
    dir = __dirname

    before ->
      fs.writeFileSync path.join(dir, filename), 'hwefwef'

    it 'should', (done) ->
      h.rmFile({dir, filename}, done)

  describe '#mvFile', ->

    filename = 'mv_src_test.txt'
    dir = destDir =  __dirname
    destFilename = 'mv_dst_test.txt'

    before ->
      fs.writeFileSync path.join(dir, filename), 'hwefwef'

    after (done) ->
      h.rmFile({filename: destFilename, dir: destDir}, done)

    it 'shoud work', (done) ->
      h.mvFile({filename, dir, destDir, destFilename}, done)

  describe '#numberOfFilesInDir', ->
    dir = path.join(__dirname, 'test_dir')

    before ->
      mkdirp.sync dir
      fs.writeFileSync path.join(dir, 'f1'), 'hey imma file 1'
      fs.writeFileSync path.join(dir, 'f2'), 'hey imma file 2'

    it 'should get the correct number of file', (done) ->
      h.numberOfFilesInDir {dir}, (err, res) ->
        should.not.exist(err)
        res.should.eql 2
        done()


      #h.numberOfFilesInDir = ({dir}, callback) ->
      #  fs.readdir dir, (err, stat) ->
      #    return callback(err) if err
      #    debug "#numberOfFilesInDir _pending photos size: #{stat.length}"
      #    callback(null, stat.length)
      #
      #h.sendEmail = (headers, callback) ->
      #  defaults =
      #    from    : 'Course Advisor <advisor@cs.stanford.edu>'
      #    to      : 'Course Advisor <advisor@cs.stanford.edu>'
      #    bcc     : 'csadvisor.bcc@gmail.com'
      #    subject : 'test email'
      #    text    : 'test text'
      #  _.defaults(headers, defaults)
      #
      #  message = email.message.create(headers)
      #  config.smtp.send(message, callback)
      #
      #
      #h.buildEmailBody = ({advisor, student, photoLink}) ->
      #
      #  switch advisor.title
      #    when 'professor' then salutation = "Dear Professor #{advisor.last},"
      #    when 'lecturer'  then salutation = "Dear #{advisor.first},"
      #    else salutation = "Dear #{advisor.first} #{advisor.last},"
      #
      #  attachments_location = ''
      #  attachments_location += "I'm attaching #{student.first}'s transcripts"
      #  attachments_location += "and including a link to a photo below." if photoLink?
      #
      #  signature = "Jack Dubie\nCS Course Advisor\nhttp://bit.ly/csadvisor"
      #  photoLink = '' unless photoLink?
      #
      #  # create email message
      #  greeting + '\n' + new_advisee + attachments_location + '\n' + signature + photoLink
      #

module.exports = h
