# Declarations should be processed fairly quickly. The website says
# it may take up to two weeks to process and Meredith sometimes takes
# up to a week to do her part, depending on how busy she is. It's best
# if you don't wait more than a few days to do your part.
#
# 1. Send the student's new advisor an e-mail informing them of the new
#    declaree. Include their transcript and portrait in the email.
#
# 2. Copy the student's picture from the camera to your computer.
#    Meredith's template currently has 6 spots, so send her photographs
#    in sets of 6 to be printed.
#
# 3. Add them to the CS Students Announce list.
#
# 4. Send the student's name and email to Connie Chan so that she can
#    add them to the Computer Forum Recruiting List.
#
# 5. Add their name/portrait to the Course Advisor Facebook Page.
#
fs      = require 'fs'
async   = require 'async'
email   = require 'lib/email'
h       = require 'lib/util/helpers'
{spawn} = require 'child_process'
debug   = require('debug')('lib/declare')


declare = (opts, callback) ->
  noFb = opts.no_fb || false

  debug 'noFb', noFb

