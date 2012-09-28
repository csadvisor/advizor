h      = require('lib/util/helpers')
should = require('should')
fs     = require('fs')
path   = require('path')
mkdirp = require('mkdirp')
async  = require('async')

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
      h.getInfo pwd: __dirname, (err, info) ->
        info.should.have.keys('student', 'advisor', 'message', 'pwd')
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

  describe '#cpFile', ->

    filename = 'cp_src_test.txt'
    dir = destDir =  __dirname
    destFilename = 'cp_dst_test.txt'

    before ->
      fs.writeFileSync path.join(dir, filename), 'hwefwef'

    after (done) ->
      async.parallel [
        (callback) -> h.rmFile({filename, dir}, callback)
        (callback) -> h.rmFile({filename: destFilename, dir: destDir}, callback)
      ], done

    it 'shoud work', (done) ->
      h.cpFile({filename, dir, destDir, destFilename}, done)

  describe '#numberOfFilesInDir', ->
    dir = path.join(__dirname, 'test_dir')

    before ->
      mkdirp.sync dir
      fs.writeFileSync path.join(dir, 'f1'), 'hey imma file 1'
      fs.writeFileSync path.join(dir, 'f2'), 'hey imma file 2'

    after ->
      fs.unlinkSync path.join(dir, 'f1')
      fs.unlinkSync path.join(dir, 'f2')
      fs.rmdirSync dir

    it 'should get the correct number of file', (done) ->
      h.numberOfFilesInDir {dir}, (err, res) ->
        should.not.exist(err)
        res.should.eql 2
        done()

      
        # This works but spammy

        #  describe '#sendEmail', ->
        #
        #    file = path.join(__dirname, 'f1')
        #
        #    before ->
        #      fs.writeFileSync(file, 'hey imma file 1')
        #
        #    after ->
        #      fs.unlinkSync(file)
        #
        #    it 'should not callback an error', (done) ->
        #      headers =
        #        to: 'jdubie2233@yahoo.com'
        #        subject: 'unit test'
        #        text: 'teeext'
        #        attachment: [
        #          { path: file, name: 'text.txt', type: 'application/text' }
        #        ]
        #      h.sendEmail(headers, done)

  describe '#buildEmailBody', ->
    it 'should be formal with professors', ->
      advisor = first: 'Mehran', last: 'Sahami', title: 'professor'
      student = first: 'John'
      body = h.buildEmailBody({advisor, student})
      body.should.match /Professor/

    it 'should be cause with non-professors', ->
      advisor = first: 'Mehran', last: 'Sahami', title: 'lecturer'
      student = first: 'John'
      body = h.buildEmailBody({advisor, student})
      body.should.not.match /Professor/


module.exports = h
