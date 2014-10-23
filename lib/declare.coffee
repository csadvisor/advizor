# Declarations should be processed fairly quickly. The website says it may
# take up to two weeks to process and Meredith sometimes takes up to a week to
# do her part, depending on how busy she is. It's best if you don't wait more
# than a few days to do your part.
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
{spawn} = require 'child_process'
_       = require 'underscore'
debug   = require('debug')('lib/declare')
h       = require './util/helpers'
tasks   = require './util/tasks'

module.exports = (argv, callback) ->
  validateTasks = _.keys(tasks)
  taskList = _.intersection(validateTasks, _.keys(argv))
  taskList = validateTasks if taskList.length is 0
  async.waterfall(wrapTasks(taskList), callback)

# wrapTasks
#
# @param tasks {Array.<String>}
# @return {Array.<Function>}
wrapTasks = (taskList) ->

  taskFunctions = (tasks[key] for key in taskList)
  
  waterfallCurry = (taskFunction) ->
    (info, next) ->
      taskFunction info, (err, res) ->
        next(err, _.extend(info, res))

  curriedTaskFunctions = taskFunctions.map (taskFunction) -> waterfallCurry(taskFunction)
  curriedTaskFunctions.unshift((callback) -> h.getInfo(pwd: process.env.PWD, callback)) # getInfo
  curriedTaskFunctions

